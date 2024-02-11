class PLeaderboard < ApplicationRecord
  belongs_to :player
  belongs_to :match

  def self.update_helper(image, match_id)
    last = PLeaderboard.where(rtype: image.rtype, rformat: image.rformat).last
    player_hash = image.rating_image[0]
    if last.nil?
      PLeaderboard.create_new(player_hash, image, match_id)
    else
      if last.player_id == player_hash['id']
        last.matches += 1
        last.highest_rating = player_hash['rating'] if player_hash['rating'] > last.highest_rating
        last.save!
      else
        PLeaderboard.create_new(player_hash, image, match_id)
      end
    end
  end

  def self.create_new(player_hash, image, match_id)
    pl = PLeaderboard.new
    pl.rtype = image.rtype
    pl.rformat = image.rformat
    pl.match_id = match_id
    pl.player_id = player_hash['id']
    pl.matches = 1
    pl.highest_rating = player_hash['rating']
    pl.save!
  end
end