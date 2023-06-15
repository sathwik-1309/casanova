class Player < ApplicationRecord
    has_many :scores
    has_many :spells
    has_one :bat_stats
    has_one :ball_stats
    has_many :performances
    def country
        return Team.find_by(id: self.country_team_id)
    end

    # private
end
