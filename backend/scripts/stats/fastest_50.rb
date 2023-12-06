def fastest_runs(fastest_to, limit)
  arr = []
  fifties = Score.where(batted: true).where("runs >= ?", fastest_to).where(tournament_id: Tournament.wt20_ids )
  fifties.each do |score|
    player = score.player
    balls = Ball.where(inning_id: score.inning_id, batsman_id: score.player_id)
    knock_runs = 0
    knock_balls = 0
    checked = false
    balls.each do |ball|
      knock_runs += ball.runs
      knock_balls += 1 unless ball.extra_type == 'wd'
      if knock_runs >= fastest_to and !checked
        temp = {
          "player_id" => score.player_id,
          "match_id" => score.match_id,
          "balls" => knock_balls,
          "score" => score.attributes,
          "vs_team" => score.inning.bow_team.abbrevation
        }
        # byebug
        arr = check_and_add(arr, temp, limit)
        checked = true
      end
    end
  end
  arr
end

def check_and_add(arr, hash, limit)
  if arr.length < limit
    arr << hash
    return arr.sort_by { |hash| hash['balls'] }
  end

  if arr[-1]['balls'] > hash['balls']
    arr.pop
    arr << hash
    return arr.sort_by { |hash| hash['balls'] }
  end
  return arr
end

fastest_to = 50

arr = fastest_runs(fastest_to, 5)
arr.each do |score|
  puts Player.find(score['player_id']).fullname.titleize
  puts "#{fastest_to} off #{score['balls']} vs #{score['vs_team']}  (match #{score['match_id']})"
  puts "total: #{score['score']['runs']} off #{score['score']['balls']}"
  puts "---------------------------------------"
end