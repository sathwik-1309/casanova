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
end
