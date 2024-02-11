class TLeaderboard < ApplicationRecord
  belongs_to :team
  belongs_to :match

  def self.update_helper(image, match_id)
    last = TLeaderboard.where(rformat: image.rformat).last
    team_hash = image.rating_image[0]
    if last.nil?
      TLeaderboard.create_new(team_hash, image, match_id)
    else
      if last.team_id == team_hash['id']
        last.matches += 1
        last.highest_rating = team_hash['rating'] if team_hash['rating'] > last.highest_rating
        last.save!
      else
        TLeaderboard.create_new(team_hash, image, match_id)
      end
    end
  end

  def self.create_new(team_hash, image, match_id)
    pl = TLeaderboard.new
    pl.rformat = image.rformat
    pl.match_id = match_id
    pl.team_id = team_hash['id']
    pl.matches = 1
    pl.highest_rating = team_hash['rating']
    pl.save!
  end
end