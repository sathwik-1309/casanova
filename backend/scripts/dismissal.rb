def individual_match_ups(matches)
  arr = []
  matches.each do |match|
    match.balls.each do |ball|
      batsman_id = ball.batsman_id
      bowler_id = ball.bowler_id
      hash = arr.find{|h| h['batsman_id']==batsman_id and h['bowler_id']==bowler_id }
      if hash.nil?
        arr << {
          'batsman_id' => batsman_id,
          'bowler_id' => bowler_id,
          'runs' => 0,
          'balls' => 0,
          'wickets' => 0,
        }
        hash = arr[-1]
      end
      hash['runs'] += ball.runs
      hash['balls'] += 1 if ball.extra_type != 'wd'
      hash['wickets'] += 1 if ball.wicket_ball
    end
  end

  arr.each do |hash|
    if hash['balls'] > 0
      hash['sr'] = ((hash['runs'].to_f * 100) / hash['balls']).round(2)
    end
  end

  arr = arr.sort_by{|h| -h['runs']}
  puts " ------------ Most Runs ------------"
  arr[0..5].each do |h|
    puts "#{Player.find(h['bowler_id']).name} to #{Player.find(h['batsman_id']).name}"
    puts "#{h['runs']} off #{h['balls']} - SR - #{h['sr']}"
    puts "#{h['wickets']} dismissals"
    puts ""
  end

  arr = arr.sort_by{|h| -h['wickets']}
  puts " ------------ Most Wickets ------------"
  arr[0..5].each do |h|
    puts "#{Player.find(h['bowler_id']).name} to #{Player.find(h['batsman_id']).name}"
    puts "#{h['runs']} off #{h['balls']} - SR - #{h['sr']}"
    puts "#{h['wickets']} dismissals"
    puts ""
  end

  arr = arr.filter{|h| h['balls'] > 6}.sort_by{|h| -h['sr']}
  puts " ------------ Best SR ------------"
  arr[0..5].each do |h|
    puts "#{Player.find(h['bowler_id']).name} to #{Player.find(h['batsman_id']).name}"
    puts "#{h['runs']} off #{h['balls']} - SR - #{h['sr']}"
    puts "#{h['wickets']} dismissals"
    puts ""
  end
end

individual_match_ups(Match.where(tournament_id: Tournament.wt20_ids))