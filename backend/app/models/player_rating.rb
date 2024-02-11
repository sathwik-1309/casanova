class PlayerRating < ApplicationRecord
  belongs_to :player

  def self.get_rank(rformat, rtype, player_id, under_50 = true)
    im = PlayerRatingImage.where(rtype: rtype, rformat: rformat).last
    hash = im.rating_image.find{|hash| hash['id'] == player_id}
    return nil if hash.nil?
    if under_50
      return nil if hash['rank'] > 50
    end
    return hash['rank']
  end

  def self.update(image, match_id)
    image.rating_image.each do |hash|
      if hash['rank'] <= 50
        pr = PlayerRating.find_by(player_id: hash['id'], rformat: image.rformat)
        if pr.nil?
          pr = PlayerRating.new
          pr.player_id = hash['id']
          pr.rformat = image.rformat
          case (image.rtype)
          when RTYPE_BAT
            pr.best_bat_rank = hash['rank']
            pr.best_bat_rating = hash['rating']
            pr.best_bat_rank_match = match_id
            pr.best_bat_rating_match = match_id
          when RTYPE_BALL
            pr.best_ball_rank = hash['rank']
            pr.best_ball_rating = hash['rating']
            pr.best_ball_rank_match = match_id
            pr.best_ball_rating_match = match_id
          when RTYPE_ALL
            pr.best_all_rank = hash['rank']
            pr.best_all_rating = hash['rating']
            pr.best_all_rank_match = match_id
            pr.best_all_rating_match = match_id
          end
          pr.save!

        else
          case (image.rtype)
          when RTYPE_BAT
            if pr.best_bat_rank.nil? or hash['rank'] < pr.best_bat_rank
              pr.best_bat_rank = hash['rank']
              pr.best_bat_rank_match = match_id
            end
            if pr.best_bat_rating.nil? or hash['rating'] > pr.best_bat_rating
              pr.best_bat_rating = hash['rating']
              pr.best_bat_rating_match = match_id
            end

          when RTYPE_BALL
            if pr.best_ball_rank.nil? or hash['rank'] < pr.best_ball_rank
              pr.best_ball_rank = hash['rank']
              pr.best_ball_rank_match = match_id
            end
            if pr.best_ball_rating.nil? or hash['rating'] > pr.best_ball_rating
              pr.best_ball_rating = hash['rating']
              pr.best_ball_rating_match = match_id
            end
            
          when RTYPE_ALL
            if pr.best_all_rank.nil? or hash['rank'] < pr.best_all_rank
              pr.best_all_rank = hash['rank']
              pr.best_all_rank_match = match_id
            end
            if pr.best_all_rating.nil? or hash['rating'] > pr.best_all_rating
              pr.best_all_rating = hash['rating']
              pr.best_all_rating_match = match_id
            end
          end
          pr.save!
        end
      end
    end
    
  end

end