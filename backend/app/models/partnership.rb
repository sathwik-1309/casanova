class Partnership < ApplicationRecord
    belongs_to :inning
    belongs_to :match
    belongs_to :tournament

    def batsman1
        return Player.find(self.batsman1_id)
    end
    def batsman2
        return Player.find(self.batsman2_id)
    end
    def bat_team
        return Squad.find(self.bat_team_id)
    end
    def bow_team
        return Squad.find(self.bow_team_id)
    end

end
