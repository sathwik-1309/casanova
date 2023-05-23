class Ball < ApplicationRecord
    belongs_to :tournament
    belongs_to :match
    belongs_to :inning
    belongs_to :over

    def batsman
        return Player.find(self.batsman_id)
    end
    def bowler
        return Player.find(self.bowler_id)
    end
end
