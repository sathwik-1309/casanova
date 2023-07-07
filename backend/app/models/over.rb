class Over < ApplicationRecord
    has_many :ball
    has_many :wicket
    belongs_to :inning
    belongs_to :match
    belongs_to :tournament

    def bowler
        return Player.find(self.bowler_id)
    end
    def get_balls
        return Ball.where(over_id: self.id)
    end
end
