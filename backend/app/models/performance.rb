class Performance < ApplicationRecord
    belongs_to :match
    belongs_to :tournament
    belongs_to :player
    belongs_to :squad

    def update_rankings(old_image, new_image)
    end

    def rank_diff(rtype)
        case rtype
        when RTYPE_BAT
            rank_before = self.rank_bat_before || 51
            rank_after = self.rank_bat_after || 51
        when RTYPE_BALL
            rank_before = self.rank_bow_before || 51
            rank_after = self.rank_bow_after || 51
        when RTYPE_ALL
            rank_before = self.rank_all_before || 51
            rank_after = self.rank_all_after || 51
        end
        diff = rank_after - rank_before
        if diff == 0
            return ''
        elsif diff > 0
            return "- #{diff}"
        else
            return "+ #{-1*diff}"
        end
    end
end
