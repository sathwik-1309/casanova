class Team < ApplicationRecord
    has_many :squads

    def get_teamname
        return "#{Util.get_flag(self.id)} #{self.name.upcase}"
    end

    def get_abb
        return "#{Util.get_flag(self.id)} #{self.abbrevation.upcase}"
    end

    def get_won_lost
        squad_ids = self.squads.pluck(:id)
        won = Match.where(winner_id: squad_ids).count
        lost = Match.where(loser_id: squad_ids).count
        return won, won+lost
    end

    def bat_stats
        arr = []
        squads = self.squads
        # players = Player.where(id: SquadPlayer.where(squad_id: squads.pluck(:id)).pluck(:id).uniq)
        stats = BatStat.where(sub_type: self.abbrevation)
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
        # players = self.players
        stats = BallStat.where(sub_type: self.abbrevation)
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

    def meta
        meta = {
            "id" => self.id,
            "color" => self.abbrevation,
            "abbrevation" => self.get_abb,
            "teamname" => self.get_teamname
        }
    end

    def get_ranking_hash
        hash = {}
        rformat = self.squads.first.tournament.name
        im = TeamRatingImage.where(rformat: rformat).last
        hash['rank'] = im.get_rank(self.id)
        hash['rating'] = im.get_rating(self.id)
        tr = TeamRating.find_by(team_id: self.id)
        hash['best_rank'] = tr.best_rank
        hash['best_rank_match'] = tr.best_rank_match
        hash['best_rating'] = tr.best_rating
        hash['best_rating_match'] = tr.best_rating_match
        hash
    end

    def team_stats
        hash = {}
        squad_ids = self.squads.pluck(:id)
        matches1 = Match.where(winner_id: squad_ids)
        matches2 = Match.where(loser_id: squad_ids)
        matches = matches1 + matches2
        matches_won = matches1.length
        win_p = (matches_won*100/matches.length).to_i
        hash['result_stats'] = {
            "total_matches" => matches.length,
            "won" => matches_won,
            "lost" => matches.length - matches_won,
            "win_p" => win_p,
            "loss_p" => 100-win_p
        }

        innings = Inning.where(bat_team_id: squad_ids)

        matches_defended = innings.where(inn_no: 1).map{|i| i.match }
        matches_won = matches_defended.select{ |m| squad_ids.include? m.winner_id }.length
        win_p = (matches_won*100/matches_defended.length).to_i
        hash['defended'] = {
            "total_matches" => matches_defended.length,
            "won" => matches_won,
            "win_p" => win_p,
            "loss_p" => 100-win_p
        }

        matches_chased = matches - matches_defended
        matches_won = matches_chased.select{ |m| squad_ids.include? m.winner_id }.length
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

    def performances
        hash = {}
        hash
    end

    def get_matches
        squad_ids = self.squads.pluck(:id)
        matches = Match.where('winner_id IN (?) OR loser_id IN (?)', squad_ids, squad_ids)
        matches
    end

    def self.head_to_head_boxes_hash(team1, team2, match_id = nil)
        squad_ids1 = team1.squads.pluck(:id)
        squad_ids2 = team2.squads.pluck(:id)
        ids = squad_ids1+squad_ids2
        matches = Match.where('winner_id IN (?) AND loser_id IN (?)', ids, ids)
        unless match_id.nil?
            matches = matches.where("id < ?", match_id)
        end
        hash = {}
        boxes = []
        h2h_record = [0,0]
        matches.each do |match|
          temp = {}
          temp['match_box'] = match.match_box
          motm = match.motm.attributes.slice('id')
          motm['name'] = match.motm.fullname.titleize
          motm['color'] = match.scores.find_by(player_id: match.motm.id).squad.team.abbrevation
          temp['motm'] = motm
          winner = {}
          winner['teamname'] = match.winner.get_teamname
          winner['color'] = match.winner.team.abbrevation
          temp['winner'] = winner
          if match.winner.team_id == team1.id
            h2h_record[0] += 1
          else
            h2h_record[1] += 1
          end
          boxes << temp
        end
        hash['boxes'] = boxes
        hash['h2h_record'] = h2h_record
        return hash
      end

end
