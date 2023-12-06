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
    has_many :player_rating_images
    has_many :player_match_points
    belongs_to :tournament
    

    after_commit do
        unless self.runs.nil?
            self.update_stats
            self.update_tournament
            self.update_player_trophies
            Uploader.update_milestone_image(self)
            self.create_schedule
            self.update_player_ratings
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
        last_match = self.tournament.schedules.where(completed: true).order(order: :desc).limit(1)
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
                to_update = self.tournament.schedules.where("`order` >= ?", order).where("`order` < ?", schedule.order)
                to_update.each do |s|
                    s.order = s.order + 1
                    s.save!
                end
            end
            schedule.order = order
            schedule.match_id = self.id
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

    def turning_point
        # score,for, overs, req rr, crr, equation (runs, balls)
        inn = self.inn2
        target = self.inn1.score + 1
        equation = {
            'runs_left' => target,
            'balls_left' => 120,
            'crr' => 0,
            'rrr' => Util.get_rr(target, 120).to_f,
            'score' => 0,
            'for' => 0,
            'delivery' => 0.0,
            'bat_team' => self.inn2.bat_team.get_abb,
            'color' => Util.get_team_color(self.tournament_id, self.winner.abbrevation)
        }
        defended = self.inn1.bat_team_id == self.winner_id ? true : false
        balls = inn.balls
        temp = []
        balls.each do |ball|
            runs_left = target - ball.score
            balls_bowled = Util.overs_to_balls(ball.delivery)
            balls_left = 120 - balls_bowled
            req_rate = Util.get_rr(runs_left, balls_left).to_f
            temp << req_rate
            check = defended ? equation['rrr'] > req_rate : equation['rrr'] < req_rate
            if check and ball.delivery < 19.6
                equation['runs_left'] = runs_left
                equation['balls_left'] = balls_left
                equation['crr'] = Util.get_rr(ball.score, balls_bowled)
                equation['rrr'] = req_rate
                equation['score'] = ball.score
                equation['for'] = ball.for
                equation['delivery'] = Util.point_6_fix(ball.delivery)
            end
        end
        equation['statement'] = "#{self.winner.get_abb} #{defended ? 'defended' : 'chased'} #{defended ? target-1 : target} with #{defended ? 'LOWEST RR' : 'HIGHEST RR'} of #{equation['rrr']}"
        equation['font'] = self.tournament.get_tour_font
        equation
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

    def batsman_points(player_bow_ratings)
        inn1 = self.inn1
        inn2 = self.inn2
        motm = self.motm_id
        points = {}
        benchmark = {}
        benchmark['runs'] = ((inn1.score + inn2.score)/(inn1.for + inn2.for).to_f).round(2)
        benchmark['sr'] = (Util.get_sr(inn1.score+inn2.score, Util.overs_to_balls(inn1.overs)+Util.overs_to_balls(inn2.overs))).to_f
        
        inn1_benchmark = {}
        inn1_benchmark['runs'] = inn1.for == 0 ? inn1.score.to_f : (inn1.score/inn1.for.to_f).round(2)
        inn1_benchmark['sr'] = Util.get_sr(inn1.score, Util.overs_to_balls(inn1.overs)).to_f
        benchmark_runs = (MATCH_WEIGHT*benchmark['runs']) + (INN_WEIGHT*inn1_benchmark['runs'])
        benchmark_sr = (MATCH_WEIGHT*benchmark['sr']) + (INN_WEIGHT*inn1_benchmark['sr'])
        bowling_team_strength = inn1.get_bow_team_strength(player_bow_ratings)

        inn1.scores.where(batted: true).each do |score|
            points[score.player_id] = score.get_points(bowling_team_strength, benchmark_runs, benchmark_sr) if score.balls > 0
        end

        inn1_benchmark = {}
        inn1_benchmark['runs'] = inn2.for == 0 ? inn2.score.to_f : (inn2.score/inn2.for.to_f).round(2)
        inn1_benchmark['sr'] = Util.get_sr(inn2.score, Util.overs_to_balls(inn2.overs)).to_f
        benchmark_runs = (MATCH_WEIGHT*benchmark['runs']) + (INN_WEIGHT*inn1_benchmark['runs'])
        benchmark_sr = (MATCH_WEIGHT*benchmark['sr']) + (INN_WEIGHT*inn1_benchmark['sr'])
        bowling_team_strength = inn2.get_bow_team_strength(player_bow_ratings)
        inn2.scores.where(batted: true).each do |score|
            points[score.player_id] = score.get_points(bowling_team_strength, benchmark_runs, benchmark_sr) if score.balls > 0
        end
        
        return points
    end

    def bowler_points(player_bat_ratings)
        inn1 = self.inn1
        inn2 = self.inn2
        motm = self.motm_id
        inn1_win = self.winner_id == inn1.bow_team_id ? true : false
      
        points = {}
      
        benchmark = {}
        balls_per_wicket = (Util.overs_to_balls(inn1.overs)+Util.overs_to_balls(inn2.overs)).to_f / (inn1.for + inn2.for)
        
        benchmark['bpw'] = balls_per_wicket.round(2)
        benchmark['economy'] = (((inn1.score+inn2.score)*6).to_f / (Util.overs_to_balls(inn1.overs)+Util.overs_to_balls(inn2.overs))).round(2)
        batting_team_strength = inn1.get_bat_team_strength(player_bat_ratings)
        inn1.spells.each do |spell|
          points[spell.player_id] = spell.get_points(benchmark, player_bat_ratings, batting_team_strength)
        end
      
        batting_team_strength = inn2.get_bat_team_strength(player_bat_ratings)
        inn2.spells.each do |spell|
          points[spell.player_id] = spell.get_points(benchmark, player_bat_ratings, batting_team_strength)
        end
      
        return points
      
    end

    def get_prev_player_rating_images
        tour_class = self.tournament.name
        tours = Tournament.where(name: tour_class)
        prev_match = Match.where(tournament_id: tours.pluck(:id)).where("id < ?", self.id).last
        if prev_match.present?
            return prev_match.get_player_rating_images
        else
            images = []
            PLAYER_RATING_RTYPES.each do |rtype|
                images << PlayerRatingImage.dummy(tour_class, rtype)
            end
            return images
        end
    end

    def get_player_rating_images
        images = []
        PLAYER_RATING_RTYPES.each do |rtype|
            images << self.player_rating_images.find_by(rtype: rtype)
        end
        return images
    end

    def update_performance_ranks
        prev_rating_images = self.get_prev_player_rating_images
        bat1 = prev_rating_images[0].rating_image
        ball1 = prev_rating_images[1].rating_image
        all1 = prev_rating_images[2]
        cur_images = self.player_rating_images
        bat2 = cur_images[0].rating_image
        ball2 = cur_images[1].rating_image
        all2 = cur_images[2]
        all1 = all1.nil? ? [] : all1.rating_image
        all2 = all2.nil? ? [] : all2.rating_image
        self.performances.each do |perf|
            hash = bat1.find{|h| h['id'] == perf.player_id}
            perf.rank_bat_before = hash['rank'] if hash.present? and hash['rank'] <= MAX_RANK
            hash = bat2.find{|h| h['id'] == perf.player_id}
            perf.rank_bat_after = hash['rank'] if hash.present? and hash['rank'] <= MAX_RANK

            hash = ball1.find{|h| h['id'] == perf.player_id}
            perf.rank_bow_before = hash['rank'] if hash.present? and hash['rank'] <= MAX_RANK
            hash = ball2.find{|h| h['id'] == perf.player_id}
            perf.rank_bow_after = hash['rank'] if hash.present? and hash['rank'] <= MAX_RANK

            hash = all1.find{|h| h['id'] == perf.player_id}
            perf.rank_all_before = hash['rank'] if hash.present? and hash['rank'] <= MAX_RANK
            hash = all2.find{|h| h['id'] == perf.player_id}
            perf.rank_all_after = hash['rank'] if hash.present? and hash['rank'] <= MAX_RANK
            perf.save!
        end
    end

    def update_player_leaderboard(new_bat_rat_image, new_ball_rat_image, new_all_rat_image)
        PLeaderboard.update_helper(new_bat_rat_image, self.id)
        PLeaderboard.update_helper(new_ball_rat_image, self.id)
        PLeaderboard.update_helper(new_all_rat_image, self.id)   
    end

    def update_player_rating_obj(new_bat_rat_image, new_ball_rat_image, new_all_rat_image)
        PlayerRating.update(new_bat_rat_image, self.id)
        PlayerRating.update(new_ball_rat_image, self.id)
        PlayerRating.update(new_all_rat_image, self.id)
    end

    def most_points_hash(rtype)
        match_points = self.player_match_points.where(rtype: rtype).order(points: :desc).limit(5)
        arr = []
        match_points.each do |mph|
            temp = mph.attributes.slice('player_id', 'points')
            temp['name'] = mph.player.name.titleize
            temp['color'] = SquadPlayer.find_by(player_id: mph.player_id, tournament_id: mph.tournament_id).squad.team.abbrevation
            arr << temp
        end
        return arr
    end

    def get_rankings_list(rtype)
        pri = PlayerRatingImage.where(rtype: rtype, rformat: self.tournament.name).where("match_id <= ?", self.id).last
        im = pri.rating_image
        arr = im.slice(0,50)
        arr.each do |hash|
            player = Player.find_by_id(hash['id'])
            case (self.tournament.name)
            when "wt20"
                team = Team.find_by_id(player.country_team_id)
            when "csl"
                team = Team.find_by_id(player.csl_team_id)
            end
            hash['teamname'] = team.get_teamname
            hash['color'] = team.abbrevation
            hash['name'] = player.fullname.titleize
        end
        return arr
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

    def update_player_ratings
        return if ENABLED_PLAYER_RATING_TOUR_CLASS.exclude? self.tournament.name
        prev_rating_images = self.get_prev_player_rating_images
        bat_rating_image = prev_rating_images[0]
        ball_rating_image = prev_rating_images[1]
        all_rating_image = prev_rating_images[2]
        
        batsman_points = self.batsman_points(bat_rating_image.rating_image)
        bowler_points = self.bowler_points(ball_rating_image.rating_image)

        batsman_points.each do |id, points|
            PlayerMatchPoint.create_new(id, points, RTYPE_BAT, self)
        end
        bowler_points.each do |id, points|
            PlayerMatchPoint.create_new(id, points, RTYPE_BALL, self)
        end

        counter = bat_rating_image.counter + 1

        if counter >= PR_PERIOD_MIN
            counter = PR_PERIOD_MIN if counter == PR_PERIOD_MAX
            if counter == PR_PERIOD_MIN
                tours = Tournament.where(name: self.tournament.name)
                m_ids = Match.where(tournament_id: tours.pluck(:id)).where("id <= ?", self.id).order(id: :desc).limit(PR_PERIOD_MIN).pluck(:id)
                new_bat_rat_image = PlayerRatingImage.construct_rating_image(bat_rating_image, m_ids, self)
                new_ball_rat_image = PlayerRatingImage.construct_rating_image(ball_rating_image, m_ids, self)
            else
                new_bat_rat_image = PlayerRatingImage.get_updated_rating_image(bat_rating_image, counter, batsman_points, self, 2)
                new_ball_rat_image = PlayerRatingImage.get_updated_rating_image(ball_rating_image, counter, bowler_points, self, 2)
            end

            # all rounder ranking
            new_all_rat_image = PlayerRatingImage.get_allr_rating_image(new_bat_rat_image, new_ball_rat_image)
                        
            self.update_performance_ranks

            self.update_player_leaderboard(new_bat_rat_image, new_ball_rat_image, new_all_rat_image)

            self.update_player_rating_obj(new_bat_rat_image, new_ball_rat_image, new_all_rat_image)
        
        else
            new_bat_rat_image = PlayerRatingImage.get_updated_rating_image(bat_rating_image, counter, batsman_points, self)
            new_ball_rat_image = PlayerRatingImage.get_updated_rating_image(ball_rating_image, counter, bowler_points, self)

        end
        
    end

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
