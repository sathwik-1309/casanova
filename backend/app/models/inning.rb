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
end
