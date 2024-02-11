class TeamRating < ApplicationRecord
  belongs_to :team

  def self.update(image, match_id)
    image.rating_image.each do |hash|
      tr = TeamRating.find_by(team_id: hash['id'], rformat: image.rformat)
      if tr.nil?
        tr = TeamRating.new
        tr.team_id = hash['id']
        tr.rformat = image.rformat
        tr.best_rank = hash['rank']
        tr.best_rating = hash['rating']
        tr.best_rank_match = match_id
        tr.best_rating_match = match_id
        tr.save!
      else
        if tr.best_rank.nil? or hash['rank'] < tr.best_rank
          tr.best_rank = hash['rank']
          tr.best_rank_match = match_id
        end
        if tr.best_rating.nil? or hash['rating'] > tr.best_rating
          tr.best_rating = hash['rating']
          tr.best_rating_match = match_id
        end
      end
      tr.save!
    end
  end
end