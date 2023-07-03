class MilestoneImage < ApplicationRecord
  belongs_to :match
  belongs_to :tournament
end
