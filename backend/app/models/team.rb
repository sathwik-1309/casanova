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
end
