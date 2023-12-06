class PlayerRatingImage < ApplicationRecord
  belongs_to :match
  belongs_to :tournament

  def self.dummy(tour_class, rtype)
    dummy = PlayerRatingImage.new
    dummy.rformat = tour_class
    dummy.rtype = rtype
    dummy.rating_image = []
    dummy.counter = 0
    return dummy
  end

  def self.get_updated_rating_image(old_image, counter, points_hash, match, weightage = 1)
    new_image = PlayerRatingImage.new
    new_image.rtype = old_image.rtype
    new_image.rformat = old_image.rformat
    new_image.counter = counter
    
    rating_image = old_image.rating_image

    points_hash.each do |id, points|
      hash = rating_image.find{|im| im['id'] == id}
      if hash.nil?
        rating_image << {'id'=> id, 'points'=>0, 'matches'=>0, 'innings'=>0, 'list'=>[]}
        hash = rating_image[-1]
      end
      hash['points'] = (hash['points'] + (points*weightage)).round(2)
      hash['innings'] += 1
      hash['list'] << {
        'match_id' => match.id,
        'points' => points,
        'weightage' => weightage
      }
      if weightage == 2
        batch1 = hash['list'].filter{|h| h['weightage'] == 1}.length
        batch2 = hash['list'].filter{|h| h['weightage'] == 2}.length
        batch1 = batch1 < PR_MIN_INNINGS_PER_HALF ? PR_MIN_INNINGS_PER_HALF : batch1
        batch2 = batch2 < PR_MIN_INNINGS_PER_HALF ? PR_MIN_INNINGS_PER_HALF : batch2
        hash['matches'] = (batch1 + (2*batch2))
      else
        hash['matches'] += (weightage)
      end
      
      hash['rating'] = (hash['points']/hash['matches']).round(2)
    end

    rating_image = rating_image.sort_by { |hash| -hash['rating'] }
    i = 1
    rating_image.each do |hash|
      hash['rank'] = i
      i += 1
    end
    new_image.rating_image = rating_image
    new_image.match_id = match.id
    new_image.tournament_id = match.tournament_id
    new_image.save!

    return new_image
  end

  def self.construct_rating_image(old_image, m_ids, match)
    # constructs an array and assigns to rating_image.image

    new_image = PlayerRatingImage.new
    new_image.rtype = old_image.rtype
    new_image.rformat = old_image.rformat
    new_image.counter = PR_PERIOD_MIN

    m_ids = m_ids.reverse

    m_ids1 = m_ids.slice(0, PR_PERIOD_HALF)
    m_ids2 = m_ids.slice(PR_PERIOD_HALF, m_ids.length - PR_PERIOD_HALF)

    match_points1 = PlayerMatchPoint.where(match_id: m_ids1, rtype: old_image.rtype)
    match_points2 = PlayerMatchPoint.where(match_id: m_ids2, rtype: old_image.rtype)

    hash = {}
    match_points1.each do |mp|
      hash[mp.player_id] = {'points'=>0, 'matches'=>0, 'innings'=>0, 'list'=>[]} unless hash.has_key? mp.player_id
      hash[mp.player_id]['points'] = (hash[mp.player_id]['points']+mp.points).round(2)
      hash[mp.player_id]['innings'] += 1
      hash[mp.player_id]['matches'] += 1
      hash[mp.player_id]['list'] << {
        'match_id' => mp.match_id,
        'points' => mp.points,
        'weightage' => 1
      }
    end

    match_points2.each do |mp|
      hash[mp.player_id] = {'points'=>0, 'matches'=>PR_MIN_INNINGS_PER_HALF, 'innings'=>0, 'list'=>[]} unless hash.has_key? mp.player_id
      hash[mp.player_id]['points'] = (hash[mp.player_id]['points']+(mp.points*2)).round(2)
      hash[mp.player_id]['innings'] += 1
      hash[mp.player_id]['matches'] += 2
      hash[mp.player_id]['list'] << {
        'match_id' => mp.match_id,
        'points' => mp.points,
        'weightage' => 2
      }
    end

    hash.each do |id, val|
      matches1 = val['list'].filter{|hash| hash['weightage'] == 1}.length
      matches2 = val['list'].filter{|hash| hash['weightage'] == 2}.length
      matches1 = matches1 < PR_MIN_INNINGS_PER_HALF ? PR_MIN_INNINGS_PER_HALF : matches1
      matches2 = matches2 < PR_MIN_INNINGS_PER_HALF ? PR_MIN_INNINGS_PER_HALF : matches2
      val['matches'] = matches1 + (2*matches2)
      val['rating'] = (val['points']/val['matches']).round(2)
    end

    arr = []
    hash.each do |key, value|
      value['id'] = key
      arr << value
    end
    
    arr = arr.sort_by{|hash| -hash['rating']}
    i = 1
    arr.each do |hash|
      hash['rank'] = i
      i += 1
    end
    
    new_image.rating_image = arr
    new_image.match_id = match.id
    new_image.tournament_id = match.tournament_id
    new_image.save!
    return new_image
  end

  def self.get_allr_rating_image(bat_image, ball_image)
    image = []
    bat_image.rating_image.each do |bat_hash|
      ball_hash = ball_image.rating_image.find{|hash| hash['id'] == bat_hash['id']}
      unless ball_hash.nil?
        allr = ((bat_hash['rating']*ball_hash['rating'])/200).round(2)
        image << {
          'id' => bat_hash['id'],
          'rating' => allr
        }
      end
    end

    image = image.sort_by{|hash| -hash['rating']}

    i = 1
    image.each do |hash|
      hash['rank'] = i
      i += 1
    end

    allr_image = PlayerRatingImage.new
    allr_image.rtype = RTYPE_ALL
    allr_image.rformat = bat_image.rformat
    allr_image.counter = bat_image.counter
    allr_image.match_id = bat_image.match_id
    allr_image.tournament_id = bat_image.tournament_id
    allr_image.rating_image = image
    allr_image.save!
    return allr_image
  end

  def get_rank(player_id, under_50 = true)
    im = self.rating_image
    hash = im.find{|hash| hash['id'] == player_id}
    return nil if hash.nil?
    if under_50
      return nil if hash['rank'] > 50
    end
    return hash['rank']
  end

  def get_rank_and_rating(player_id, under_50 = true)
    im = self.rating_image
    hash = im.find{|hash| hash['id'] == player_id}
    return 1000, 0 if hash.nil?
    if under_50
      return 1000, hash['rating'].to_i || 0 if hash['rank'] > 50
    end
    return hash['rank'], hash['rating'].to_i
  end

end