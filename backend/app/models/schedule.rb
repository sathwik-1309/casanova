class Schedule < ApplicationRecord
  belongs_to :tournament

  def squad1
    return Squad.find(self.squad1_id)
  end
  def squad2
    return Squad.find(self.squad2_id)
  end
end
