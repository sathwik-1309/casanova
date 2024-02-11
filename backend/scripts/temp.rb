PERIOD_MAX = 40
PERIOD_MIN = 32
PERIOD_HALF = 16

MIN_INNINGS_PER_HALF = 3
MOTM_POINTS = 40
WIN_POINTS = 20
PP_WEIGHT = 1
MID_WEIGHT = 1
DEATH_WEIGHT = 1

MATCH_WEIGHT = 0.8
INN_WEIGHT = 0.2

DEFAULT_BATSMAN_RATING = 120
DEFAULT_ALLROUNDER_RATING = 80
DEFAULT_BOWLER_RATING = 10

TEAM_STRENGTH_BAT_AVG = 100
TEAM_STRENGTH_WEIGHTAGE = 0

TEAM_STRENGTH_BOW_AVG = 120

def player_ratings(matches)
  bat_ratings = []
  player_bat_ratings = []
  bow_ratings = []
  player_bow_ratings = []
  leaderboard = {}
  first = nil
  leaderboard_bow = {}
  first_bow = nil
  avg = []
  counter = 0
  matches.each do |match|
    batsmen = {}
    bowlers = {}
    inn1 = match.inn1
    inn2 = match.inn2

    batsman_points = match.batsman_points(player_bat_ratings)
    bowler_points = match.bowler_points(player_bow_ratings)
    
    if bat_ratings.length >= PERIOD_MIN
      if bat_ratings.length == PERIOD_MAX
        bat_ratings.slice!(0, PERIOD_MAX - PERIOD_MIN)
      end

      if bat_ratings.length == PERIOD_MIN
        player_bat_ratings = {}
        first_array = bat_ratings.slice(0, PERIOD_HALF)
        second_array = bat_ratings.slice(PERIOD_HALF, bat_ratings.length - PERIOD_HALF)

        first_array.each do |ratings|
          ratings.each do |rating|
            id = rating['id']
            player_bat_ratings[id] = {'points' => 0, 'matches'=>0, 'inn'=>0} unless player_bat_ratings.has_key? id
            player_bat_ratings[id]['points'] = (player_bat_ratings[id]['points']+rating['points']).round(2)
            player_bat_ratings[id]['matches'] += 1
            player_bat_ratings[id]['inn'] += 1
          end
        end

        player_bat_ratings.each do |id, value|
          matches = player_bat_ratings[id]['matches'] < (MIN_INNINGS_PER_HALF) ? (MIN_INNINGS_PER_HALF) : player_bat_ratings[id]['matches']
          player_bat_ratings[id]['matches'] = matches
        end

        second_array.each do |ratings|
          ratings.each do |rating|
            id = rating['id']
            player_bat_ratings[id] = {'points' => 0, 'matches'=> MIN_INNINGS_PER_HALF, 'inn'=>0} unless player_bat_ratings.has_key? id
            player_bat_ratings[id]['points'] = (player_bat_ratings[id]['points']+(rating['points']*2)).round(2)
            player_bat_ratings[id]['matches'] += 2
            player_bat_ratings[id]['inn'] += 1
          end
        end

        player_bat_ratings.each do |id, value|
          x = player_bat_ratings[id]['matches'] - 3
          matches = x < (MIN_INNINGS_PER_HALF*2) ? player_bat_ratings[id]['matches']+(MIN_INNINGS_PER_HALF*2) : player_bat_ratings[id]['matches']
          player_bat_ratings[id]['rating'] = (player_bat_ratings[id]['points'].to_f/matches).round(2)
        end

      else
        bat_ratings[-1].each do |rating|
          id = rating['id']
          player_bat_ratings[id] = {'points' => 0, 'matches'=>0, 'inn'=>0} unless player_bat_ratings.has_key? id
          player_bat_ratings[id]['points'] = (player_bat_ratings[id]['points']+(rating['points']*2)).round(2)
          player_bat_ratings[id]['matches'] += 2
          player_bat_ratings[id]['inn'] += 1
          matches = player_bat_ratings[id]['matches'] < (MIN_INNINGS_PER_HALF*3) ? (MIN_INNINGS_PER_HALF*3) : player_bat_ratings[id]['matches']
          player_bat_ratings[id]['rating'] = (player_bat_ratings[id]['points'].to_f/matches).round(2)
        end
        
      end

      player_bat_ratings_arr = player_bat_ratings.sort_by { |key, value| - value['rating'] }

      if player_bat_ratings_arr[0][0] == first
        leaderboard[first] = {'times'=>1, 'matches'=>0} unless leaderboard.has_key? first
        leaderboard[first]['matches'] += 1
      else
        first = player_bat_ratings_arr[0][0]
        leaderboard[first] = {'times'=>0, 'matches'=>0} unless leaderboard.has_key? first
        leaderboard[first]['times'] += 1
        leaderboard[first]['matches'] += 1
      end
    else
      bat_ratings[-1].each do |rating|
        id = rating['id']
        player_bat_ratings[id] = {'points' => 0, 'matches'=>0} unless player_bat_ratings.has_key? id
        player_bat_ratings[id]['points'] = (player_bat_ratings[id]['points']+rating['points']).round(2)
        player_bat_ratings[id]['matches'] += 1
        player_bat_ratings[id]['rating'] = (player_bat_ratings[id]['points']/player_bat_ratings[id]['matches']).round(2)
      end
    end

    if bow_ratings.length >= PERIOD_MIN
      if bow_ratings.length == PERIOD_MAX
        bow_ratings.slice!(0, PERIOD_MAX - PERIOD_MIN)
      end

      if bow_ratings.length == PERIOD_MIN
        player_bow_ratings = {}
        first_array = bow_ratings.slice(0, PERIOD_HALF)
        second_array = bow_ratings.slice(PERIOD_HALF, bow_ratings.length - PERIOD_HALF)

        first_array.each do |ratings|
          ratings.each do |rating|
            id = rating['id']
            player_bow_ratings[id] = {'points' => 0, 'matches'=>0, 'inn'=>0} unless player_bow_ratings.has_key? id
            player_bow_ratings[id]['points'] = (player_bow_ratings[id]['points']+rating['points']).round(2)
            player_bow_ratings[id]['matches'] += 1
            player_bow_ratings[id]['inn'] += 1
          end
        end

        player_bow_ratings.each do |id, value|
          matches = player_bow_ratings[id]['matches'] < MIN_INNINGS_PER_HALF ? MIN_INNINGS_PER_HALF : player_bow_ratings[id]['matches']
          player_bow_ratings[id]['matches'] = matches
        end

        second_array.each do |ratings|
          ratings.each do |rating|
            id = rating['id']
            player_bow_ratings[id] = {'points' => 0, 'matches'=> MIN_INNINGS_PER_HALF, 'inn'=>0} unless player_bow_ratings.has_key? id
            player_bow_ratings[id]['points'] = (player_bow_ratings[id]['points']+(rating['points']*2)).round(2)
            player_bow_ratings[id]['matches'] += 2
            player_bow_ratings[id]['inn'] += 1
          end
        end

        player_bow_ratings.each do |id, value|
          x = player_bow_ratings[id]['matches'] - 3
          matches = x < (MIN_INNINGS_PER_HALF*2) ? player_bow_ratings[id]['matches']+(MIN_INNINGS_PER_HALF*2) : player_bow_ratings[id]['matches']
          player_bow_ratings[id]['rating'] = (player_bow_ratings[id]['points'].to_f/matches).round(2)
        end

      else
        bow_ratings[-1].each do |rating|
          id = rating['id']
          player_bow_ratings[id] = {'points' => 0, 'matches'=>0, 'inn'=>0} unless player_bow_ratings.has_key? id
          player_bow_ratings[id]['points'] = (player_bow_ratings[id]['points']+(rating['points']*2)).round(2)
          player_bow_ratings[id]['matches'] += 2
          player_bow_ratings[id]['inn'] += 1
          matches = player_bow_ratings[id]['matches'] < (MIN_INNINGS_PER_HALF*3) ? (MIN_INNINGS_PER_HALF*3) : player_bow_ratings[id]['matches']
          player_bow_ratings[id]['rating'] = (player_bow_ratings[id]['points'].to_f/matches).round(2)
        end
        
      end

      player_bow_ratings_arr = player_bow_ratings.sort_by { |key, value| - value['rating'] }

      if player_bow_ratings_arr[0][0] == first_bow
        leaderboard_bow[first_bow] = {'times'=>1, 'matches'=>0} unless leaderboard_bow.has_key? first_bow
        leaderboard_bow[first_bow]['matches'] += 1
      else
        first_bow = player_bow_ratings_arr[0][0]
        leaderboard_bow[first_bow] = {'times'=>0, 'matches'=>0} unless leaderboard_bow.has_key? first_bow
        leaderboard_bow[first_bow]['times'] += 1
        leaderboard_bow[first_bow]['matches'] += 1
      end
    else
      bow_ratings[-1].each do |rating|
        id = rating['id']
        player_bow_ratings[id] = {'points' => 0, 'matches'=>0} unless player_bow_ratings.has_key? id
        player_bow_ratings[id]['points'] = (player_bow_ratings[id]['points']+rating['points']).round(2)
        player_bow_ratings[id]['matches'] += 1
        player_bow_ratings[id]['rating'] = (player_bow_ratings[id]['points']/player_bow_ratings[id]['matches']).round(2)
      end
    end

  end

  player_bat_ratings_arr = player_bat_ratings.sort_by { |key, value| - value['rating'] }
  player_bow_ratings_arr = player_bow_ratings.sort_by { |key, value| - value['rating'] }

  i = 0
  while i < 10
    puts "#{i+1} - #{Player.find(player_bat_ratings_arr[i][0]).name} - #{player_bat_ratings_arr[i][1]}"
    i += 1
  end
  leaderboard.each do |id, val|
    puts "#{Player.find(id).name} - matches #{val['matches']} - times #{val['times']}"
  end

  i = 0
  while i < 10
    puts "#{i+1} - #{Player.find(player_bow_ratings_arr[i][0]).name} - #{player_bow_ratings_arr[i][1]}"
    i += 1
  end
  leaderboard_bow.each do |id, val|
    puts "#{Player.find(id).name} - matches #{val['matches']} - times #{val['times']}"
  end
  
end

def player_ratings_inn(inn, batsmen, bowlers)
  inn.balls.each do |ball|
    batter = ball.batsman_id
    bowler = ball.bowler_id
    batsmen[batter] = {} unless batsmen.has_key? batter
    batter_hash = batsmen[batter]
    if ball.delivery <= 6.0
      phase = 'pp'
    elsif ball.delivery <= 16.0
      phase = 'mid'
    else
      phase = 'death'
    end
    batter_hash[phase] = {
      'runs' => 0,
      'balls' => 0,
      'bowlers' => {}
    } unless batter_hash.has_key? phase
    batter_hash[phase]['runs'] += ball.runs
    batter_hash[phase]['balls'] += 1 if ball.extra_type != 'nb'
    batter_hash[phase]['bowlers'][bowler] = {'runs' => 0, 'balls' => 0} unless batter_hash[phase]['bowlers'].has_key? bowler
    batter_hash[phase]['bowlers'][bowler]['runs'] += ball.runs
    batter_hash[phase]['bowlers'][bowler]['balls'] += 1 if ball.extra_type != 'nb'

    bowlers[bowler] = {} unless bowlers.has_key? bowler
    bowler_hash = bowlers[bowler]
    bowler_hash[phase] = {
      'runs' => 0,
      'balls' => 0,
      'wickets' => 0
    } unless bowler_hash.has_key? phase
    bowler_hash[phase]['runs'] += ball.bow_runs
    bowler_hash[phase]['balls'] += 1 if ['wd', 'nb'].exclude? ball.extra_type
    bowler_hash[phase]['wickets'] += 1 if ball.wicket_ball
  end
  
  return batsmen, bowlers
end

def match_bat_ratings(match, bat_ratings, player_bow_ratings)
  inn1 = match.inn1
  inn2 = match.inn2
  motm = match.motm_id
  inn1_win = match.winner_id == inn1.bat_team_id ? true : false
  points = {}
  benchmark = {}
  benchmark['runs'] = ((inn1.score + inn2.score)/(inn1.for + inn2.for).to_f).round(2)
  benchmark['sr'] = (Util.get_sr(inn1.score+inn2.score, Util.overs_to_balls(inn1.overs)+Util.overs_to_balls(inn2.overs))).to_f
  
  inn1_benchmark = {}
  inn1_benchmark['runs'] = inn1.for == 0 ? inn1.score.to_f : (inn1.score/inn1.for.to_f).round(2)
  inn1_benchmark['sr'] = Util.get_sr(inn1.score, Util.overs_to_balls(inn1.overs)).to_f
  benchmark_runs = (MATCH_WEIGHT*benchmark['runs']) + (INN_WEIGHT*inn1_benchmark['runs'])
  benchmark_sr = (MATCH_WEIGHT*benchmark['sr']) + (INN_WEIGHT*inn1_benchmark['sr'])
  inn1.scores.where(batted: true).each do |score|
    points = add_batsman_points_inn(inn1, score, points, player_bow_ratings, benchmark_runs, benchmark_sr)
  end

  inn1_benchmark = {}
  inn1_benchmark['runs'] = inn2.for == 0 ? inn2.score.to_f : (inn2.score/inn2.for.to_f).round(2)
  inn1_benchmark['sr'] = Util.get_sr(inn2.score, Util.overs_to_balls(inn2.overs)).to_f
  benchmark_runs = (MATCH_WEIGHT*benchmark['runs']) + (INN_WEIGHT*inn1_benchmark['runs'])
  benchmark_sr = (MATCH_WEIGHT*benchmark['sr']) + (INN_WEIGHT*inn1_benchmark['sr'])
  inn2.scores.where(batted: true).each do |score|
    points = add_batsman_points_inn(inn2, score, points, player_bow_ratings, benchmark_runs, benchmark_sr)
  end

  points = points.sort_by { |key, value| - value }
  match_bat_ratings = []
  points.each do |player|
    match_bat_ratings << {
      'id' => player[0],
      'points' => player[1]
    }
    # puts "#{Player.find(player[0]).name} - #{player[1]}"
  end
  bat_ratings << match_bat_ratings
  return bat_ratings
end

def match_bow_ratings(match, bow_ratings, player_bat_ratings)
  inn1 = match.inn1
  inn2 = match.inn2
  motm = match.motm_id
  inn1_win = match.winner_id == inn1.bow_team_id ? true : false

  points = {}

  benchmark = {}
  balls_per_wicket = (Util.overs_to_balls(inn1.overs)+Util.overs_to_balls(inn2.overs)).to_f / (inn1.for + inn2.for)
  
  benchmark['bpw'] = balls_per_wicket.round(2)
  benchmark['economy'] = (((inn1.score+inn2.score)*6).to_f / (Util.overs_to_balls(inn1.overs)+Util.overs_to_balls(inn2.overs))).round(2)
  
  inn1.spells.each do |spell|
    points = add_bowler_points_inn(inn1, spell, benchmark, points, player_bat_ratings)
  end

  inn2.spells.each do |spell|
    points = add_bowler_points_inn(inn2, spell, benchmark, points, player_bat_ratings)
  end

  points = points.sort_by { |key, value| - value }
  match_bow_ratings = []
  points.each do |player|
    match_bow_ratings << {
      'id' => player[0],
      'points' => player[1]
    }
    # puts "#{Player.find(player[0]).name} - #{player[1]}"
  end
  bow_ratings << match_bow_ratings
  return bow_ratings

end

def get_wicket_weight(player_bat_ratings, wicket, bat_rat)
  case (wicket.batsman.skill)
  when 'bat'
    default = DEFAULT_BATSMAN_RATING
  when 'all'
    default = DEFAULT_ALLROUNDER_RATING
  when 'bow'
    default = DEFAULT_BOWLER_RATING
  end
  if player_bat_ratings[wicket.batsman_id].present?
    bat_rat << player_bat_ratings[wicket.batsman_id]['rating'] + default + 50
  else
    bat_rat << (default.to_f*1.5) + 50
  end
  return bat_rat
end

def add_bowler_points_inn(inn, spell, benchmark, points, player_bat_ratings)
  spell_balls = Util.overs_to_balls(spell.overs)
  bpo =  spell_balls / spell.wickets.to_f
  part1 = benchmark['bpw'] / bpo
  part2 = benchmark['economy'] / spell.economy
  bat_rat = []
  inn.wickets.where(bowler_id: spell.player_id).each do |wicket|
    bat_rat = get_wicket_weight(player_bat_ratings, wicket, bat_rat)
  end
  avg_wicket_weight = bat_rat.present? ? (bat_rat.sum.to_f/bat_rat.length).round(2) : 0
  calculated_points = (((part2*spell_balls*10) + (part1*avg_wicket_weight)) / 2).round(2)
  if ["league", "group"].exclude? inn.match.stage
    if inn.match.stage == "final"
      factor = 1.2
    else
      factor = 1.1
    end
    calculated_points = (calculated_points*factor).round(2)
  end
  points[spell.player_id] = ((calculated_points*TEAM_STRENGTH_WEIGHTAGE*get_bat_team_strength(inn, player_bat_ratings)) + (calculated_points*(0.9))).round(2)
  return points
end

def add_batsman_points_inn(inn1, score, points, player_bow_ratings, benchmark_runs, benchmark_sr)
  return if score.balls < 0
  not_out_points = score.not_out ? 6 : 0
  sr = score.sr.nil? ? 0 : score.sr
  part1 = ((score.runs+not_out_points)/benchmark_runs)*sr
  part2 = (sr/benchmark_sr)*score.runs*5
  motm_points = score.player_id == inn1.match.motm_id ? MOTM_POINTS : 0
  win_points = inn1.match.winner_id == inn1.bat_team.id ? WIN_POINTS : 0
  calculated_points = (part1 + part2 + motm_points + win_points).round(2)
  if ["league", "group"].exclude? inn1.match.stage
    if inn1.match.stage == "final"
      factor = 1.2
    else
      factor = 1.1
    end
    calculated_points = (calculated_points*factor).round(2)
  end

  points[score.player_id] =  calculated_points*(1.0-TEAM_STRENGTH_WEIGHTAGE) + (TEAM_STRENGTH_WEIGHTAGE*calculated_points*get_bow_team_strength(inn1, player_bow_ratings))
  return points
end

def get_bat_team_strength(inn, player_bat_ratings)
  rats = []
  inn.scores.each do |score|
    case (score.player.skill)
    when 'bat'
      default = DEFAULT_BATSMAN_RATING*2
    when 'all'
      default = DEFAULT_ALLROUNDER_RATING*2
    when 'bow' 
      default = DEFAULT_BOWLER_RATING*2
    end
    if player_bat_ratings[score.player_id].present?
      if player_bat_ratings[score.player_id]['rating'] < default
        rats << default
      else
        rats << player_bat_ratings[score.player_id]['rating']
      end
      
    else
      rats << default
    end
  end
  
  strength = (rats.sum.to_f/rats.length).round(2)
  return ((strength-TEAM_STRENGTH_BAT_AVG)/TEAM_STRENGTH_BAT_AVG).round(2)
end

def get_bow_team_strength(inn, player_bow_ratings)
  rats = []
  avg_strength = TEAM_STRENGTH_BOW_AVG + 80
  inn.get_overs.each do|over|
    if player_bow_ratings[over.bowler_id].present?
      if player_bow_ratings[over.bowler_id]['rating'] < avg_strength
        rats << avg_strength
      else
        rats << player_bow_ratings[over.bowler_id]['rating']
      end
    else
      rats << avg_strength
    end
  end
  
  strength = (rats.sum.to_f/rats.length).round(2)
  ret = ((strength-TEAM_STRENGTH_BOW_AVG)/TEAM_STRENGTH_BOW_AVG).round(2)
  return ret
end

points = player_ratings(Match.where(tournament_id: Tournament.wt20_ids))

afg = [1202, 834, 1163, 840]
ban = [1476, 960, 1407, 960]
pak = [1188, 826, 1229, 839]

jan - [pant, faf, rinku, asalanka]
feb - [hetmyer, harshal, naib, chapman]
mar - [malan, arshdeep, reeza, dk]
apr - [bishnoi, shepherd, mukesh, mathews]
may - [marsh, mir, asalanka, agar, ishan]
june - [rashid, krunal, chameera, jaiswal]
july - [pathirana, imad, thakur, lungi]
aug - [sodhi, rajapaksa, holder]
sept - [nawaz, mehidy]
oct - [madushanka, archer, ellis, neesham]
nov - [shamsi, brook, amir, shanaka]
dec - [ashwin]

jan, may, june, oct, dec, nov, july, aug, mar, sept, apr, feb
jan, oct, may, june, nov, mar, dec, july, aug, feb, apr, sept
may, jan, june, oct, nov, july, dec, mar, aug, feb, sept, apr
may, june, jan, oct, dec, july, mar, nov, apr, aug, feb, sept