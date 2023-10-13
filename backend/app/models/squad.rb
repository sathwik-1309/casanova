class Squad < ApplicationRecord
    belongs_to :tournament
    belongs_to :team
    has_many :performances
    has_many :scores
    has_many :spells

    def keeper
        return Player.find(self.keeper_id)
    end
    def captain
        return Player.find(self.captain_id)
    end
    def get_players
        player_ids = Performance.where(squad_id: self.id).pluck(:player_id)
        return Player.where(id: player_ids|[])
    end
    def players
        player_ids = SquadPlayer.where(squad_id: self.id).pluck(:player_id)
        return Player.where(id: player_ids)
    end
    def matches_list
        match_ids = Match.where(winner_id: self.id).pluck(:id)
        match_ids += Match.where(loser_id: self.id).pluck(:id)
        return Match.where(id: match_ids)
    end
    def get_nrr
        match_ids = Match.where(winner_id: self.id, stage: ['league', 'group']).pluck(:id)
        match_ids += Match.where(loser_id: self.id, stage: ['league', 'group']).pluck(:id)
        if match_ids == []
            return 0.0
        end
        runs_list = []
        overs_list = []
        runs_conceded_list = []
        overs_bowled_list = []
        match_ids.each do|match|
            bat_innings = Inning.find_by(match_id: match.to_i, bat_team_id: self.id)
            runs = bat_innings.score
            wickets = bat_innings.for
            if wickets == 10
                overs = 20.0
            else
                overs = bat_innings.overs
            end
            runs_list.append(runs)
            overs_list.append(overs)

            ball_innings = Inning.find_by(match_id: match.to_i, bow_team_id: self.id)
            runs_conceded = ball_innings.score
            wickets_taken = ball_innings.for
            if wickets_taken == 10
                overs_bowled = 20.0
            else
                overs_bowled = ball_innings.overs
            end
            runs_conceded_list.append(runs_conceded)
            overs_bowled_list.append(overs_bowled)
        end
        nrr = ((runs_list.sum.to_f / overs_list.sum.to_f) - (runs_conceded_list.sum.to_f / overs_bowled_list.sum.to_f)).round(2)
        return nrr
    end

    def get_teamname
        return "#{Util.get_flag(self.team_id)} #{self.name.upcase}"
    end

    def get_abb
        return "#{Util.get_flag(self.team_id)} #{self.abbrevation.upcase}"
    end

    def squad_box
        temp = {}
        temp['name'] = self.get_teamname
        temp['abbrevation'] = self.get_abb
        temp['color'] = self.abbrevation
        temp['id'] = self.id
        temp
    end

    def get_won_lost
        squad_ids = self.id
        won = Match.where(winner_id: squad_ids).count
        lost = Match.where(loser_id: squad_ids).count
        return won, won+lost
    end

    def schedule
        arr = []
        squad = self
        games = Schedule.where("squad1_id = ? or squad2_id =?", squad.id, squad.id)
        games.each do |schedule|
            temp = schedule.schedule_box
            if temp['squad1']['color'] != squad.abbrevation
                temp['squad1'], temp['squad2'] = temp['squad2'], temp['squad1']
            end
            arr << temp
        end
        arr
    end

    def top_players
        hash = {}
        bat_stats = self.bat_stats
        hash['most_runs'] = bat_stats[0].slice("player", "runs", "innings")
        hash['best_score'] = bat_stats.sort_by{|stat| [-stat['best']['score'].to_i, stat['best']['balls']]}[0].slice("best", "player")
        hash['best_sr'] = bat_stats.filter{|stat| stat['runs'] > 50 }.sort_by{|stat| -stat['sr']} [0].slice("player", "sr", "runs")
        ball_stats = self.ball_stats
        hash['most_wickets'] = ball_stats[0].slice("player", "wickets", "innings")
        hash['best_spell'] = ball_stats.sort_by{|stat| [-stat['best']['wickets'].to_i, stat['best']['runs']] }[0].slice("best", "player")
        hash['best_economy'] = ball_stats.filter{|stat| stat['overs'] > 8}.sort_by{|stat| stat['economy']}[0].slice("player", "economy", "wickets")
        
        hash
    end

    def bat_stats
        arr = []
        players = self.players
        stats = BatStat.where(sub_type: "tour_#{self.tournament_id}", player_id: players.pluck(:id))
                .where("runs > 0").order(runs: :desc)
        stats.each do |stat|
            temp = stat.attributes.slice('matches', 'innings', 'runs', 'sr', 'avg', 'c4', 'c6', 'thirties', 'fifties', 'hundreds', 'boundary_p', 'dot_p')
            temp['player'] = stat.player.attributes.slice('id', 'name', 'fullname')
            best = Inning.find_by_id(stat.best_id).scores.find_by(player_id: stat.player_id)
            temp['best'] = best.score_box
            arr << temp
        end
        arr
    end

    def ball_stats
        arr = []
        players = self.players
        stats = BallStat.where(sub_type: "tour_#{self.tournament_id}", player_id: players.pluck(:id))
                .where("overs > 0").order(wickets: :desc)
        stats.each do |stat|
            temp = stat.attributes.slice('matches', 'innings', 'overs', 'maidens', 'wickets', 'economy', 'sr', 'avg', 'three_wickets', 'five_wickets', 'boundary_p', 'dot_p')
            temp['player'] = stat.player.attributes.slice('id', 'name', 'fullname')
            best = Inning.find_by_id(stat.best_id).spells.find_by(player_id: stat.player_id)
            temp['best'] = best.spell_box
            arr << temp
        end
        arr
    end

    def squad_stats
        hash = {}
        matches = Match.where("winner_id = ? or loser_id = ?", self.id, self.id)
        matches_won = matches.select{ |m| m.winner_id == self.id }.length
        win_p = (matches_won*100/matches.length).to_i
        hash['result_stats'] = {
            "total_matches" => matches.length,
            "won" => matches_won,
            "lost" => matches.length - matches_won,
            "win_p" => win_p,
            "loss_p" => 100-win_p
        }

        innings = Inning.where(bat_team_id: self.id)

        matches_defended = innings.where(inn_no: 1).map{|i| i.match }
        matches_won = matches_defended.select{ |m| m.winner_id == self.id }.length
        win_p = (matches_won*100/matches_defended.length).to_i
        hash['defended'] = {
            "total_matches" => matches_defended.length,
            "won" => matches_won,
            "win_p" => win_p,
            "loss_p" => 100-win_p
        }

        matches_chased = matches - matches_defended
        matches_won = matches_chased.select{ |m| m.winner_id == self.id }.length
        win_p = (matches_won*100/matches_chased.length).to_i
        hash['chased'] = {
            "total_matches" => matches_chased.length,
            "won" => matches_won,
            "win_p" => win_p,
            "loss_p" => 100-win_p
        }

        highest_total = innings.order(score: :desc).limit(1)&.first
        lowest_total = innings.where("overs >= 20 or for == 10").order(score: :asc).limit(1)&.first
        rr_array = innings.map{|i| i.get_rr.to_f }
        avg_rr = rr_array.length != 0 ? (rr_array.sum/rr_array.length).round(2) : nil
        hash['total_stats'] = {
            "highest_total" => highest_total&.squad_stats,
            "lowest_total" => lowest_total&.squad_stats,
            "avg_total" => avg_rr.nil? ? nil : (avg_rr*20).round(2)
        }
        hash
    end

    def meta
        meta = {
            "id" => self.id,
            "color" => self.abbrevation,
            "abbrevation" => self.get_abb,
            "teamname" => self.get_teamname,
            "tour" => self.tournament.get_tour_with_season
        }
    end

end
