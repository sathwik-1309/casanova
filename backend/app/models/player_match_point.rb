class PlayerMatchPoint < ApplicationRecord
  belongs_to :match
  belongs_to :tournament
  belongs_to :player

  def self.create_new(id, points, rtype, match)
    mp = PlayerMatchPoint.new
    mp.player_id = id
    mp.points = points
    mp.rtype = rtype
    mp.rformat =  match.tournament.name
    mp.match_id = match.id
    mp.tournament_id = match.tournament_id
    mp.save!
  end

end