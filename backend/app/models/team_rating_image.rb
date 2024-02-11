class TeamRatingImage < ApplicationRecord
  belongs_to :match
  belongs_to :tournament

  def self.dummy(tour_class)
    dummy = TeamRatingImage.new
    dummy.rformat = tour_class
    dummy.rating_image = []
    dummy.counter = 0
    return dummy
  end

  def get_rating(team_id)
    im = self.rating_image
    hash = im.find{|hash| hash['id'] == team_id}
    if hash.nil?
      return 100
    else
      return hash['rating']
    end
  end

  def get_rank(team_id)
    im = self.rating_image
    hash = im.find{|hash| hash['id'] == team_id}
    if hash.nil?
      return nil
    else
      return hash['rank']
    end
  end

  def self.get_rank_diff(old, hash)
    old_hash = old.rating_image.find{|x| x['id'] == hash['id']}
    old_rank = old_hash.present? ? old_hash['rank'] : nil
    rank_diff = hash['rank'] - old_rank
    color = 'green'
    if rank_diff > 0
      rank_diff = "- #{rank_diff}"
      color = 'red'
    elsif rank_diff == 0
      rank_diff = nil
    else
      rank_diff = "+ #{rank_diff*(-1)}"
    end
    return old_rank, rank_diff, color
  end

  def self.construct_rating_image(prev_rating_image, m_ids, match)
    new_image = TeamRatingImage.new
    new_image.rformat = prev_rating_image.rformat
    new_image.counter = TR_PERIOD_MIN

    m_ids = m_ids.reverse

    m_ids1 = m_ids.slice(0, TR_PERIOD_HALF)
    m_ids2 = m_ids.slice(TR_PERIOD_HALF, m_ids.length - TR_PERIOD_HALF)

    match_points1 = TeamMatchPoint.where(match_id: m_ids1)
    match_points2 = TeamMatchPoint.where(match_id: m_ids2)

    hash = {}
    match_points1.each do |mp|
      hash[mp.team_id] = {'points'=>0, 'matches'=>0, 'innings'=>0, 'list'=>[]} unless hash.has_key? mp.team_id
      hash[mp.team_id]['points'] = (hash[mp.team_id]['points']+mp.points).round(2)
      hash[mp.team_id]['innings'] += 1
      hash[mp.team_id]['matches'] += 1
      hash[mp.team_id]['list'] << {
        'match_id' => mp.match_id,
        'points' => mp.points,
        'weightage' => 1
      }
    end

    match_points2.each do |mp|
      hash[mp.team_id] = {'points'=>0, 'matches'=>TR_MIN_INNINGS_PER_HALF, 'innings'=>0, 'list'=>[]} unless hash.has_key? mp.team_id
      hash[mp.team_id]['points'] = (hash[mp.team_id]['points']+(mp.points*2)).round(2)
      hash[mp.team_id]['innings'] += 1
      hash[mp.team_id]['matches'] += 2
      hash[mp.team_id]['list'] << {
        'match_id' => mp.match_id,
        'points' => mp.points,
        'weightage' => 2
      }
    end

    hash.each do |id, val|
      matches1 = val['list'].filter{|hash| hash['weightage'] == 1}.length
      matches2 = val['list'].filter{|hash| hash['weightage'] == 2}.length
      matches1 = matches1 < TR_MIN_INNINGS_PER_HALF ? TR_MIN_INNINGS_PER_HALF : matches1
      matches2 = matches2 < TR_MIN_INNINGS_PER_HALF ? TR_MIN_INNINGS_PER_HALF : matches2
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

  def self.get_updated_rating_image(old_image, counter, t1, t2, match, weightage=1)
    new_image = TeamRatingImage.new
    new_image.rformat = old_image.rformat
    new_image.counter = counter
    
    rating_image = old_image.rating_image

    [t1, t2].each do |x|
      id = x['id']
      points = x['points']
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
        batch1 = batch1 < TR_MIN_INNINGS_PER_HALF ? TR_MIN_INNINGS_PER_HALF : batch1
        batch2 = batch2 < TR_MIN_INNINGS_PER_HALF ? TR_MIN_INNINGS_PER_HALF : batch2
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
end