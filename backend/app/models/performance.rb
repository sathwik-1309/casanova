class Performance < ApplicationRecord
    belongs_to :match
    belongs_to :tournament
    belongs_to :player
    belongs_to :squad
end
