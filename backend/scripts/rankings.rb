PERIOD_MIN = 40
PERIOD_MAX = 50
PERIOD_HALF = 20

def match_rating(match, t1, t2, dict)
  inn1 = match.inn1
  inn2 = match.inn2
  rr1 = Util.get_rr(inn1.score, inn1.for == 10 ? 120 : Util.overs_to_balls(inn1.overs)).to_f
  rr2 = Util.get_rr(inn2.score, inn2.for == 10 ? 120 : Util.overs_to_balls(inn2.overs)).to_f
  if match.winner_id == inn1.bat_team_id
    nrr = (rr1 - rr2)
    raise StandardError.new("negative nrr") if rr2 > rr1
  else
    nrr = (rr2 - rr1)
    raise StandardError.new("negative nrr") if rr1 > rr2
  end
  eff_nrr = nrr == 0 ? 0.01 : nrr
  h1 = dict[t1.id] > dict[t2.id] ? t1 : t2
  h2 = h1.id == t1.id ? t2 : t1
  if match.winner.team_id == h1.id
    ratio = dict[h2.id]/dict[h1.id]
  else
    ratio = dict[h1.id]/dict[h2.id]
  end
  return (eff_nrr*ratio)
end

def rankings(matches)
  res_dict = {}
  first = {
    "id" => nil,
    "points" => 0
  }
  counter = 0
  rats = []
  leaderboard = {}
  ratings_arr = []
  ratings_dict2 = {}
  matches.each do|match|
    if ratings_arr.length >= PERIOD_MIN
      if ratings_arr.length == PERIOD_MAX
        ratings_arr.slice!(0, PERIOD_MAX - PERIOD_MIN)
      end
      if ratings_arr.length == PERIOD_MIN
        ratings_dict2 = {}
        first_array = ratings_arr.slice(0, PERIOD_HALF)
        second_array = ratings_arr.slice(PERIOD_HALF, ratings_arr.length - PERIOD_HALF)

        first_array.each do |match|
          t1 = match[0]
          t2 = match[1]
          ratings_dict2[t1[0]] = {'points'=>800, 'matches'=>0} unless ratings_dict2.has_key? t1[0]
          ratings_dict2[t2[0]] = {'points'=>800, 'matches'=>0} unless ratings_dict2.has_key? t2[0]
          ratings_dict2[t1[0]]['points'] = (ratings_dict2[t1[0]]['points'] + (t1[1]/2)).round(2)
          ratings_dict2[t2[0]]['points'] = (ratings_dict2[t2[0]]['points'] + (t2[1]/2)).round(2)
          ratings_dict2[t1[0]]['matches'] += 1
          ratings_dict2[t2[0]]['matches'] += 1
        end

        second_array.each do |match|
          t1 = match[0]
          t2 = match[1]
          ratings_dict2[t1[0]] = {'points'=>800, 'matches'=>0} unless ratings_dict2.has_key? t1[0]
          ratings_dict2[t2[0]] = {'points'=>800, 'matches'=>0} unless ratings_dict2.has_key? t2[0]
          ratings_dict2[t1[0]]['points'] = (ratings_dict2[t1[0]]['points'] + t1[1]).round(2)
          ratings_dict2[t2[0]]['points'] = (ratings_dict2[t2[0]]['points'] + t2[1]).round(2)
          ratings_dict2[t1[0]]['matches'] += 1
          ratings_dict2[t2[0]]['matches'] += 1
        end
        first = {
          'id' => nil,
          'points' => 0
        }
        ratings_dict2.each do |key, value|
          if first['points'] < value['points'] and ratings_dict2[key]['matches'] >= 4
            first['id'] = key
            first['points'] = value['points']
          end
        end
      end
    end

    t1 = Team.find_by_id(match.winner.team_id)
    t2 = Team.find_by_id(match.loser.team_id)
    res_dict[t1.id] = 800 unless res_dict.has_key? t1.id
    res_dict[t2.id] = 800 unless res_dict.has_key? t2.id

    rating = match_rating(match, t1, t2, res_dict)
    rats << {
      'id' => match.id,
      'rating' => rating
    }
    if match.stage == "group" or match.stage == "league"
      factor = 0
      consolation = 0
    elsif match.stage == "final"
      factor = 10
      consolation = 5
    else
      factor = 6
      consolation = 3
    end

    winner_rating = 12 + (10*rating) + factor
    loser_rating = consolation - 10 - (10*rating)
    res_dict[t1.id] = (res_dict[t1.id] + winner_rating).round(2)
    res_dict[t2.id] = (res_dict[t2.id] + loser_rating).round(2)

    if ratings_arr.length >= PERIOD_MIN
      ratings_dict2[t1.id] = {'points'=>0, 'matches'=>0} unless ratings_dict2.has_key? t1.id
      ratings_dict2[t2.id] = {'points'=>0, 'matches'=>0} unless ratings_dict2.has_key? t2.id
      ratings_dict2[t1.id]['points'] = (ratings_dict2[t1.id]['points'] + winner_rating).round(2)
      ratings_dict2[t2.id]['points'] = (ratings_dict2[t2.id]['points'] + loser_rating).round(2)
      ratings_dict2[t1.id]['matches'] += 1
      ratings_dict2[t2.id]['matches'] += 1
    end
    
    # if first['points'] < res_dict[t1.id] and first['id']!= t1.id
    #   counter += 1
    #   leaderboard[t1.id] = {'times' => 0, 'matches' => 1} unless leaderboard.has_key? t1.id
    #   leaderboard[t1.id]['times'] += 1
    #   first['points'] = res_dict[t1.id]
    #   first['id'] = t1.id
    # else
    #   leaderboard[first['id']]['matches'] += 1
    # end

    if ratings_arr.length >= PERIOD_MIN and first['points'] < ratings_dict2[t1.id]['points'] and first['id']!= t1.id and ratings_dict2[t1.id]['matches'] >= 4
      counter += 1
      leaderboard[t1.id] = {'times' => 0, 'matches' => 1} unless leaderboard.has_key? t1.id
      leaderboard[t1.id]['times'] += 1
      first['points'] = ratings_dict2[t1.id]['points']
      first['id'] = t1.id
    elsif ratings_arr.length >= PERIOD_MIN
      leaderboard[first['id']] = {'times' => 1, 'matches' => 0} unless leaderboard.has_key? first['id']
      leaderboard[first['id']]['matches'] += 1
    end

    ratings_arr << [[t1.id, winner_rating], [t2.id, loser_rating]]
    
  end
  rankings = res_dict.sort_by { |key, value| - value }
  rankings2 = ratings_dict2.sort_by { |key, value| - value['points'] }
  i = 0
  # rankings.each do|key, value|
  #   i += 1
  #   puts "#{i}. #{Team.find_by_id(key).abbrevation.titleize} - #{value}"
  # end

  puts "-----------------------"
  i = 0
  rankings2.each do|key, value|
    i += 1
    puts "#{i}. #{Team.find_by_id(key).abbrevation.titleize} - #{value}"
  end

  puts "Counter #{counter}"
  puts "Leaderboard #{leaderboard}"
  avg = rats.map{|r| r['rating']}.sum/rats.length
  rats = rats.sort_by{|r| r['rating']}
  puts "Average rating #{avg}"
  puts "Smallest rating match_id - #{rats[0]['id']}, #{rats[0]['rating']}"
  puts "Largest rating match_id - #{rats[-1]['id']}, #{rats[-1]['rating']}"
end

rankings(Match.where(tournament_id: Tournament.wt20_ids))