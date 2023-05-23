class Team < ApplicationRecord
    has_many :squads

    def get_teamname
        return "#{Util.get_flag(self.id)} #{self.name.upcase}"
    end
    def get_abb
        return "#{Util.get_flag(self.id)} #{self.abbrevation.upcase}"
    end
end
