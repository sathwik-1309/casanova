class Wicket < ApplicationRecord
    belongs_to :tournament
    belongs_to :match
    belongs_to :inning
    belongs_to :over
    belongs_to :ball

    def bowler
        return Player.find(self.bowler_id)
    end
    def batsman
        return Player.find(self.batsman_id)
    end
    def fielder
        return Player.find(self.fielder_id)
    end
    def get_data1
        return "b #{self.bowler.name.titleize}"
    end
    def get_data2
        if self.method == 'b'
            return ""
        elsif self.method == 'c'
            return "c #{self.fielder.name.titleize}"
        elsif self.method == 'st'
            return "st #{self.fielder.name.titleize}"
        elsif self.method == 'lbw'
            return "lbw"
        elsif self.method == 'hit'
            return "hit wicket"
        else
            return "method not found #{self.method}"
        end
    end

    def get_wicket_weight(player_bat_ratings)
        case (self.batsman.skill)
        when 'bat'
          default = DEFAULT_BATSMAN_RATING
        when 'all'
          default = DEFAULT_ALLROUNDER_RATING
        when 'bow'
          default = DEFAULT_BOWLER_RATING
        end
        if player_bat_ratings[self.batsman_id].present?
          return player_bat_ratings[self.batsman_id]['rating'] + default + 50
        else
          return (default.to_f*1.5) + 50
        end
    end
end
