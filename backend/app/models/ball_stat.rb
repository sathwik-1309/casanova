class BallStat < ApplicationRecord
    belongs_to :player

    def best
        return Spell.find_by(player_id: self.id, inning_id: self.best_id)
    end
end
