def wicket_diff_list(matches)
  teams = []
  matches.each do |match|
    t1 = match.inn1.bat_team.team
    t2 = match.inn1.bow_team.team
    t1_hash = teams.find{|t| t['id'] == t1.id}
    if t1_hash.nil?
      teams << {'name'=> t1.name, 'id'=> t1.id, 'diff'=>0, 'taken'=>0, 'lost'=>0, 'mat'=>0}
      t1_hash = teams[-1]
    end
    
    t2_hash = teams.find{|t| t['id'] == t2.id}
    if t2_hash.nil?
      teams << {'name'=> t2.name,'id'=> t2.id, 'diff'=>0, 'taken'=>0, 'lost'=>0, 'mat'=>0}
      t2_hash = teams[-1]
    end

    t1_hash['mat'] += 1
    t2_hash['mat'] += 1

    w = match.inn1.for
    t1_hash['lost'] += w
    t1_hash['diff'] -= w
    t2_hash['taken'] += w
    t2_hash['diff'] += w

    w = match.inn2.for
    t2_hash['lost'] += w
    t2_hash['diff'] -= w
    t1_hash['taken'] += w
    t1_hash['diff'] += w
  end

  puts "Diff table"
  teams = teams.sort_by{|hash| -hash['diff']}
  i = 0
  teams.each do |team|
    i += 1
    puts "#{i} - #{team['name']} - #{team['diff']}"
  end

  puts ""
  puts "Wickets taken"
  teams = teams.sort_by{|hash| -hash['taken']}
  i = 0
  teams.each do |team|
    i += 1
    puts "#{i} - #{team['name']} - #{team['taken']}"
  end

  puts ""
  puts "Wickets lost"
  teams = teams.sort_by{|hash| -hash['lost']}
  i = 0
  teams.each do |team|
    i += 1
    puts "#{i} - #{team['name']} - #{team['lost']}"
    team['avg_taken'] = (team['taken'].to_f/team['mat']).round(1)
    team['avg_lost'] = (team['lost'].to_f/team['mat']).round(1)
  end

  puts ""
  puts "Avg taken"
  teams = teams.sort_by{|hash| -hash['avg_taken']}
  i = 0
  teams.each do |team|
    i += 1
    puts "#{i} - #{team['name']} - #{team['avg_taken']}"
  end

  puts ""
  puts "Avg lost"
  teams = teams.sort_by{|hash| -hash['avg_lost']}
  i = 0
  teams.each do |team|
    i += 1
    puts "#{i} - #{team['name']} - #{team['avg_lost']}"
  end
end

wicket_diff_list(Match.where(tournament_id: Tournament.wt20_ids))