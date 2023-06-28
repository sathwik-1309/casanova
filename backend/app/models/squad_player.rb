class SquadPlayer < ApplicationRecord
  belongs_to :tournament
  belongs_to :team
  belongs_to :player
  belongs_to :squad
end
