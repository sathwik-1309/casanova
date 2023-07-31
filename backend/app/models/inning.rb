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
    def spells
        spells = Spell.where(inning_id: self.id)
        overs = Over.where(inning_id: self.id)
        bowlers = []
        overs.each do |over|
            if bowlers.exclude? over.bowler_id
                bowlers << over.bowler_id
            end
        end
        ret_spells = []
        l = spells.length
        bowlers.each do |bowler|
            i = 0
            flag = true
            while i<l and flag
                if spells[i].player_id == bowler
                    flag = false
                    ret_spells << spells[i]
                end
                i+=1
            end
        end
        return ret_spells
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
        inn['worm_color'] = WORM_COLORS[Util.get_team_color(self.tournament_id, bat_team.abbrevation)]
        inn['rr'] = self.get_rr
        inn['score'] = Util.get_score(self.score, self.for)
        inn['overs'] = self.overs
        return inn
    end

    def get_score
        return Util.get_score(self.score, self.for)
    end
end
