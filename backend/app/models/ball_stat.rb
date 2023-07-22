class BallStat < ApplicationRecord
    belongs_to :player

    def self.create_db_entry(p_id, sub_type)
        b = BallStat.new
        b.player_id = p_id
        b.sub_type = sub_type
        b.innings = 0
        b.overs = 0
        b.maidens = 0
        b.runs = 0
        b.wickets = 0
        b.economy = 0
        b.sr = 0
        b.avg = 0
        b.wides = 0
        b.no_balls = 0
        b.dots = 0
        b.c1 = 0
        b.c2 = 0
        b.c3 = 0
        b.c4 = 0
        b.c6 = 0
        b.three_wickets = 0
        b.five_wickets = 0
        b.dot_p = 0
        b.boundary_p = 0
        unless b.save
            puts "❌ ball_stat#create_db_entry: failed to save new entry"
            return nil
        end
        return b
    end

    def best
        return Spell.find_by(player_id: self.player_id, inning_id: self.best_id)
    end

    def get_hash
        h = {}
        # self.player.matches
        h['matches'] = self.matches
        h['innings'] = self.innings
        h['overs'] = self.overs
        h['wickets'] = self.wickets
        h['economy'] = self.economy
        h['maidens'] = self.maidens
        h['sr'] = self.sr
        h['avg'] = self.avg
        h['dot_p'] = self.dot_p
        h['boundary_p'] = self.boundary_p
        h['fours'] = self.c4
        h['sixes'] = self.c6
        h['three_wickets'] = self.three_wickets
        h['five_wickets'] = self.five_wickets
        h['best_spell'] = self.best_id.nil? ? nil : Spell.find_by(player_id: self.player_id, inning_id: self.best_id).spell_box
        return h
    end
end
