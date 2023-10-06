class Match < ApplicationRecord
    has_many :balls
    has_many :overs
    has_many :innings
    has_many :wicket
    has_many :scores
    has_many :spells
    has_many :scores
    has_many :spells
    has_many :partnerships
    has_many :performances
    belongs_to :tournament

    after_commit do
        unless self.runs.nil?
            self.update_stats
            self.update_tournament
            self.update_player_trophies
            Uploader.update_milestone_image(self)
            self.create_schedule
        end
    end

    def inn1
        return Inning.find(self.inn1_id)
    end
    def inn2
        return Inning.find(self.inn2_id)
    end
    def winner
        return Squad.find(self.winner_id)
    end
    def loser
        return Squad.find(self.loser_id)
    end
    def toss
        return Squad.find(self.toss_id)
    end
    def motm
        return Player.find(self.motm_id)
    end

    def schedule
        query1 = Schedule.find_by(venue: self.venue, squad1_id: self.winner_id, squad2_id: loser_id, stage: self.stage)
        query2 = Schedule.find_by(venue: self.venue, squad2_id: self.winner_id, squad1_id: loser_id, stage: self.stage)
        query1 or query2
    end

    def get_tour_font
        return "#{Tournament.find(self.tournament_id).name}_#{self.tournament_id}"
    end

    def create_schedule
        last_match = self.tournament.schedules.order(order: :desc).limit(1)
        if self.schedule.nil?
            schedule = Schedule.new
            schedule.squad1_id = self.winner_id
            schedule.squad2_id = self.loser_id
            schedule.venue = self.venue
            schedule.stage = self.stage
            schedule.completed = true
            schedule.match_id = self.id
            schedule.tournament_id = self.tournament_id
            schedule.order = last_match.present? ? last_match.first.order+1 : 1
        else
            schedule = self.schedule
            schedule.completed = true
            order = last_match.present? ? last_match.first.order+1 : 1
            unless schedule.order == order
                to_update = self.tournament.schedules.where("order >= ?", order).where("order < ?", schedule.order)
                to_update.each do |s|
                    s.order = s.order + 1
                    s.save!
                end
            end
            schedule.order = order
        end
        schedule.save!
    end

    def match_box
        hash = {}
        inn1 = self.inn1
        inn2 = self.inn2
        hash["inn1"] = {}
        hash["inn1"]["teamname"] = inn1.bat_team.get_abb
        hash["inn1"]["won"] = self.winner_id == inn1.bat_team_id
        if self.winner_id == inn1.bat_team_id
            hash["inn1"]["score"] = "⭐️ #{Util.get_score(inn1.score, inn1.for)}"
        else
            hash["inn1"]["score"] = "#{Util.get_score(inn1.score, inn1.for)}"
        end


        hash["inn1"]["color"] = Util.get_team_color(self.tournament_id, inn1.bat_team.abbrevation)
        hash["inn2"] = {}
        hash["inn2"]["teamname"] = inn2.bat_team.get_abb
        hash["inn2"]["won"] = self.winner_id == inn2.bat_team_id
        if self.winner_id == inn2.bat_team_id
            hash["inn2"]["score"] = "⭐️ #{Util.get_score(inn2.score, inn2.for)}"
        else
            hash["inn2"]["score"] = "#{Util.get_score(inn2.score, inn2.for)}"
        end
        hash["inn2"]["color"] = Util.get_team_color(self.tournament_id, inn2.bat_team.abbrevation)

        hash["tour"] = self.get_tour_font
        hash["tour_name"] = "#{Tournament.find(self.tournament_id).name.upcase}"
        hash["venue"] = self.venue.titleize
        hash["m_id"] = self.id
        return hash
    end

    def get_journey_result(squad)
        squad_id = squad.id
        if self.winner_id == squad_id
            if self.win_by_wickets.nil? and self.win_by_runs.nil?
                return "won by Super Over".upcase
            elsif self.win_by_wickets.nil?
                return "won by #{self.win_by_runs} Runs".upcase
            else
                return "won by #{self.win_by_wickets} Wickets".upcase
            end
        else
            if self.win_by_wickets.nil? and self.win_by_runs.nil?
                return "lost by Super Over".upcase
            elsif self.win_by_wickets.nil?
                return "lost by #{self.win_by_runs} Runs".upcase
            else
                return "lost by #{self.win_by_wickets} Wickets".upcase
            end
        end
    end

    def get_highlights_hash
        arr = []
        scores = self.scores.where('runs >= 50')
        scores.each do|score|
            score_type = "50"
            score_ss = 50
            arr << self.get_highlights_hash_score(score, score_ss, score_type)
            if score.runs >= 100
                score_type = "100"
                score_ss = 100
                arr << self.get_highlights_hash_score(score, score_ss, score_type)
            end
        end
        spells = self.spells.where('wickets >= 3')
        spells.each do|spell|
            spell_type = "3W-haul"
            spell_ss = 3
            arr << self.get_highlights_hash_spell(spell, spell_ss, spell_type)
            if spell.wickets >= 5
                spell_type = "5W-haul"
                spell_ss = 5
                arr << self.get_highlights_hash_spell(spell, spell_ss, spell_type)
            end
        end
        arr
    end

    def self.innings_phase_performers_hash(innings, phase)
        case phase
        when 'powerplay'
            balls = innings.balls.where('delivery <= 6.0')
        when 'middle'
            balls = innings.balls.where('delivery >= 6.0 and delivery < 15.0')
        when 'death'
            balls = innings.balls.where('delivery >= 15.0')
        end
        return Match.get_phase_performers(balls, innings)
    end

    def update_tournament
        if self.stage == 'final'
            Uploader.update_tournament_after_final(self)
        end
    end

    def result_statement
        if self.win_by_runs.nil?
            info = "#{self.win_by_wickets} WICKETS"
        else
            info = "#{self.win_by_runs} RUNS"
        end
        "#{self.winner.get_abb} BEAT #{self.loser.get_abb} BY #{info}"
    end

    private

    def self.get_phase_performers(balls, innings)
        batsmen = {}
        bowlers = {}
        balls.each do |ball|
            unless batsmen.has_key? ball.batsman_id.to_s
                p_id = ball.batsman_id.to_s
                batsmen[p_id] = {
                  "p_id" => p_id,
                  "name" => Player.find(p_id).name.titleize,
                  "runs" => 0,
                  "balls" => 0,
                  "out" => false,
                  "color" => Util.get_team_color(innings.tournament_id, innings.bat_team.abbrevation)
                }
            end
            unless bowlers.has_key? ball.bowler_id.to_s
                p_id = ball.bowler_id.to_s
                bowlers[p_id] = {
                  "p_id" => p_id,
                  "name" => Player.find(p_id).name.titleize,
                  "balls" => 0,
                  "runs" => 0,
                  "wickets" => 0,
                  "color" => Util.get_team_color(innings.tournament_id, innings.bow_team.abbrevation)
                }
            end
            batsmen, bowlers = Match.update_player_hashes(ball, batsmen, bowlers)
        end
        batsman = batsmen.values.sort_by{|b| -b["runs"]}[0]
        bowlers.keys.each do|b|
            bowlers[b]["economy"] = Util.get_rr(bowlers[b]["runs"], bowlers[b]["balls"])
        end
        bowler = bowlers.values.sort_by{|b|[-b["wickets"], b["economy"].to_f]}[0]
        unless bowler.nil?
            bowler["overs"] = Util.format_overs(Util.balls_to_overs(bowler["balls"]))
            bowler["fig"] = "#{bowler["wickets"]}-#{bowler["runs"]}"
        end
        unless batsman.nil?
            unless batsman["out"]
                batsman["runs"] = "#{batsman["runs"]}*"
            end
        end
        return batsman, bowler
    end

    def self.update_player_hashes(ball, batsmen, bowlers)
        bat_runs = ball.runs - ball.extras
        bat = batsmen[ball.batsman_id.to_s]
        bat["balls"] += 1 unless ball.extra_type == 'wd'
        bat["runs"] += bat_runs
        bat["out"] = true if ball.wicket_ball
        bow = bowlers[ball.bowler_id.to_s]
        bow["balls"] += 1 unless ['wd', 'nb'].include? ball.extra_type
        bow["runs"] += ball.bow_runs
        bow["wickets"] += 1 if ball.wicket_ball
        return batsmen, bowlers
    end

    def update_stats
        Uploader.update_bat_stats(self)
        Uploader.update_ball_stats(self)
    end

    def get_highlights_hash_spell(spell, spell_ss, spell_type)
        temp = {}
        team = spell.squad.team
        temp['color'] = Util.get_team_color(self.tournament_id, team.abbrevation)
        p_id = spell.player_id
        tour_class_ids = Tournament.where(name: self.tournament.name).pluck(:id)
        p_spells = Spell.where(player_id: p_id, match_id: 1..self.id, wickets: spell_ss..Float::INFINITY)
        overall_ = p_spells.length
        tour_class_ = p_spells.select { |spell| tour_class_ids.include? spell.tournament_id }.length
        tour_ = p_spells.select { |spell| spell.tournament_id == self.tournament_id }.length
        team_ = p_spells.select { |spell| team.squads.pluck(:id).include? spell.squad_id }.length
        temp['message'] = "#{spell.player.name.titleize}'s' #{Util.ordinal_suffix(tour_class_)} #{spell_type} in #{self.tournament.name}"
        temp['others'] = [
          "#{Util.ordinal_suffix(tour_)} #{spell_type} in this tournament",
          "#{Util.ordinal_suffix(team_)} #{spell_type} for #{team.get_abb}",
          "#{Util.ordinal_suffix(overall_)} #{spell_type} overall"
        ]
        temp
    end

    def get_highlights_hash_score(score, score_ss, score_type)
        temp = {}
        team = score.squad.team
        temp['color'] = Util.get_team_color(self.tournament_id, team.abbrevation)
        p_id = score.player_id
        tour_class_ids = Tournament.where(name: self.tournament.name).pluck(:id)
        p_scores = Score.where(player_id: p_id, match_id: 1..self.id, runs: score_ss..Float::INFINITY)
        overall_ = p_scores.length
        tour_class_ = p_scores.select { |score| tour_class_ids.include? score.tournament_id }.length
        tour_ = p_scores.select { |score| score.tournament_id == self.tournament_id }.length
        team_ = p_scores.select { |score| team.squads.pluck(:id).include? score.squad_id }.length
        temp['message'] = "#{score.player.name.titleize}'s' #{Util.ordinal_suffix(tour_class_)} #{score_type} in #{self.tournament.name}"
        temp['others'] = [
          "#{Util.ordinal_suffix(tour_)} #{score_type} in this tournament",
          "#{Util.ordinal_suffix(team_)} #{score_type} for #{team.get_abb}",
          "#{Util.ordinal_suffix(overall_)} #{score_type} overall"
        ]
        temp
    end

    def self.get_inn_hash_for_phase_performers(inn, innings_progression)
        inn1 = {}
        inn1['teamname'] = inn.bat_team.get_teamname
        inn1['color'] = Util.get_team_color(inn.tournament_id, inn.bat_team.abbrevation)
        inn1['score'] = inn.get_score
        inn1['overs'] = inn.overs
        ['powerplay', 'middle', 'death'].each do|phase|
            inn1[phase] = {}
            inn1[phase]['performers'] = Match.innings_phase_performers_hash(inn, phase)
            unless innings_progression[phase][inn.inn_no-1].nil?
                inn1[phase]['total_score'] = innings_progression[phase][inn.inn_no-1]["total_score"]
                inn1[phase]['phase_score'] = innings_progression[phase][inn.inn_no-1]["score"]
            else
                inn1[phase]['score'] = nil
            end
        end
        return inn1
    end


    def self.innings_progression_hash(innings, stage)
        case stage
        when 'powerplay'
            o = innings.get_overs.find_by(over_no: 6)
            Match.return_progression_hash(o.score, o.for, innings, o.score, o.for)
        when 'middle'
            o = innings.get_overs.find_by(over_no: 6)
            prev_score = o.score
            prev_for = o.for
            o2 = innings.get_overs.where('over_no <= 15').order(over_no: :desc).limit(1).first
            score = o2.score - prev_score
            wickets = o2.for - prev_for
            Match.return_progression_hash(score, wickets, innings, o2.score, o2.for)
        when 'death'
            o = innings.get_overs.find_by(over_no: 15)
            if o.nil?
                return nil
            else
                prev_score = o.score
                prev_for = o.for
                o2 = innings.get_overs.where('over_no > 15').order(over_no: :desc).limit(1).first
                unless o2.nil?
                    score = o2.score - prev_score
                    wickets = o2.for - prev_for
                    Match.return_progression_hash(score, wickets, innings, o2.score, o2.for)
                else
                    Match.return_progression_hash(score, wickets, innings, nil, nil)
                end

            end

        end
    end

    private

    def self.return_progression_hash(runs, wickets, innings, total_runs, total_wickets)
        return nil if runs.nil?
        total_score = "#{total_runs}-#{total_wickets}" unless total_runs.nil?
        return {
          "score" => "#{runs}-#{wickets}",
          "color" => Util.get_team_color(innings.tournament_id, innings.bat_team.abbrevation),
          "teamname" =>  innings.bat_team.abbrevation.upcase,
          "height" => [runs*4, 400].min,
          "total_score" => total_score,
        }
    end

    def update_player_trophies
        self.reload
        Uploader.increment_player_trophies(self)
    end
end
