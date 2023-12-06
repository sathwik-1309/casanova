class Inning < ApplicationRecord
    has_many :balls
    has_many :over
    belongs_to :match
    has_many :wickets
    has_many :scores
    has_many :spells
    has_many :partnerships
    belongs_to :tournament

    def bat_team
        return Squad.find(self.bat_team_id)
    end
    def bow_team
        return Squad.find(self.bow_team_id)
    end
    def scores
        return Score.where(inning_id: self.id).order(score_id: :asc)
    end
    
    def get_overs
        return Over.where(inning_id: self.id)
    end

    def get_rr
        rr = Util.get_rr(self.score, Util.overs_to_balls(self.overs))
        return rr
    end

    def get_worm_details
        inn = {}
        bat_team = self.bat_team
        inn['teamname'] = bat_team.get_abb
        inn['team_id'] = bat_team.team_id
        team_scores = Over.where(inning_id: self.id).pluck(:score)
        wicket_overs = Over.where(id: Wicket.where(inning_id: self.id).pluck(:over_id)).pluck(:over_no)
        inn['scores'] = [0] + team_scores
        inn['wickets'] = wicket_overs.uniq
        inn['color'] = Util.get_team_color(self.tournament_id, bat_team.abbrevation)
        # inn['worm_color'] = WORM_COLORS[Util.get_team_color(self.tournament_id, bat_team.abbrevation)]
        inn['worm_color'] = WORM_COLORS[bat_team.abbrevation]
        inn['rr'] = self.get_rr
        inn['score'] = Util.get_score(self.score, self.for)
        inn['overs'] = self.overs
        return inn
    end

    def get_score
        return Util.get_score(self.score, self.for)
    end

    def squad_stats
        hash = {}
        hash['score'] = self.get_score
        hash['vs_team'] = self.bow_team.get_abb
        hash['match_id'] = self.match_id
        hash
    end

    def get_bow_team_strength(player_bow_ratings)
        rats = []
        avg_strength = TEAM_STRENGTH_BOW_AVG + 80
        self.get_overs.each do|over|
          hash = player_bow_ratings.find{|h| h['id'] == over.bowler_id}
          if hash.present?
            if hash['rating'] < avg_strength
              rats << avg_strength
            else
              rats << hash['rating']
            end
          else
            rats << avg_strength
          end
        end
        
        strength = (rats.sum.to_f/rats.length).round(2)
        ret = ((strength-TEAM_STRENGTH_BOW_AVG)/TEAM_STRENGTH_BOW_AVG).round(2)
        return ret
    end

    def get_bat_team_strength(player_bat_ratings)
        rats = []
        self.scores.each do |score|
          case (score.player.skill)
          when 'bat'
            default = DEFAULT_BATSMAN_RATING*2
          when 'all'
            default = DEFAULT_ALLROUNDER_RATING*2
          when 'bow' 
            default = DEFAULT_BOWLER_RATING*2
          end
          hash = player_bat_ratings.find{|h| h['id'] == score.player_id}
          if hash.present?
            if hash['rating'] < default
              rats << default
            else
              rats << hash['rating']
            end
            
          else
            rats << default
          end
        end
        
        strength = (rats.sum.to_f/rats.length).round(2)
        return ((strength-TEAM_STRENGTH_BAT_AVG)/TEAM_STRENGTH_BAT_AVG).round(2)
      end

    def get_squad_hash
        arr = []
        perfs = self.match.performances
        self.scores.each do |score|
            temp = {}
            player = score.player
            temp['id'] = score.player_id
            temp['pos'] = score.position
            temp['skill'] = score.player.skill
            perf = perfs.find_by(player_id: player.id)
            temp['bat_rank'] = perf.rank_bat_after || 1000
            temp['bat_rank_diff'] = perf.rank_diff(RTYPE_BAT)
            temp['bow_rank'] = perf.rank_bow_after || 1000
            temp['bow_rank_diff'] = perf.rank_diff(RTYPE_BALL)
            temp['all_rank'] = perf.rank_all_after || 1000
            temp['all_rank_diff'] = perf.rank_diff(RTYPE_ALL)
            temp['skill'] = 'wk' if perf.keeper
            temp['name'] = player.name.titleize
            temp['captain'] == perf.keeper
            temp['bat_points'] = score.match.player_match_points.find_by(rtype: RTYPE_BAT, player_id: player.id)&.points || 0
            temp['bow_points'] = score.match.player_match_points.find_by(rtype: RTYPE_BALL, player_id: player.id)&.points || 0
            arr << temp
        end
        hash = {}
        hash['teamname'] = self.bat_team.get_teamname
        hash['color'] = Util.get_team_color(self.match.tournament_id ,self.bat_team.abbrevation)
        hash['squad'] = arr
        return hash
    end
end

