class BatStat < ApplicationRecord
    belongs_to :player

    def self.create_db_entry(p_id, sub_type)
        b = BatStat.new
        b.player_id = p_id
        b.sub_type = sub_type
        b.innings = 0
        b.runs = 0
        b.balls = 0
        b.sr = 0
        b.avg = 0
        b.not_outs = 0
        b.dots = 0
        b.c1 = 0
        b.c2 = 0
        b.c3 = 0
        b.c4 = 0
        b.c6 = 0
        b.thirties = 0
        b.fifties = 0
        b.hundreds = 0
        b.boundary_p = 0
        b.dot_p = 0
        unless b.save
            puts "❌ bat_stat#create_db_entry: failed to save new entry"
            return nil
        end
        return b
    end

    def best
        return Score.find_by(player_id: self.player_id, inning_id: self.best_id)
    end
end
