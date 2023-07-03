class Ball < ApplicationRecord
    belongs_to :tournament
    belongs_to :match
    belongs_to :inning
    belongs_to :over

    # tags
    TAG_W = "tag_W"
    TAG_4 = "tag_4"
    TAG_6 = "tag_6"
    TAG_DEFAULT = "tag_default"
    TAG_WIDE = "tag_wide"
    TAG_NB = "tag_nb"

    def batsman
        return Player.find(self.batsman_id)
    end
    def bowler
        return Player.find(self.bowler_id)
    end

    def get_result_and_tag
        if self.wicket_ball
            return "W", TAG_W
        elsif self.extra_type.nil?
            return self.runs, Ball.get_tag(self.runs)
        else
            case extra_type
            when "wd"
                wd = "#{self.extras-1}"
                wd = "" if wd == "0"
                return "#{wd}wd", TAG_WIDE
            when "nb"
                return "#{self.runs}nb", TAG_NB
            when "lb"
                return "#{self.extras}lb", TAG_DEFAULT
            when "b"
                return "#{self.extras}lb", TAG_DEFAULT
            end
        end
    end

    private

    def self.get_tag(runs)
        case runs
        when 4
            return TAG_4
        when 6
            return TAG_6
        end
        return TAG_DEFAULT
    end
end
