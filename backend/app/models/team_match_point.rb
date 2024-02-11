class TeamMatchPoint < ApplicationRecord
  belongs_to :match
  belongs_to :tournament
  belongs_to :team

  def self.create_new(id, points, match)
    mp = TeamMatchPoint.new
    mp.team_id = id
    mp.points = points
    mp.rformat =  match.tournament.name
    mp.match_id = match.id
    mp.tournament_id = match.tournament_id
    mp.save!
  end

end