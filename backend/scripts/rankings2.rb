matches = Match.where(tournament_id: Tournament.wt20_ids)
rankings = []

def find(rankings, team_id)
  i = 0
  while i < rankings.length
    if rankings[i]['id'] == team_id
      return i
    end
    i += 1
  end
  return nil
end

matches.each do |match|
  t1 = match.winner.team_id
  t2 = match.loser.team_id
  t1_index = find(rankings, t1)
  if t1_index.nil?
    rankings << {
      'id' => t1,
      'points' => 0,
      'matches' => 0,
      'total_matches' => 0,
      'list' => []
    }
  end
  if t2_index.nil?
    rankings << {
      'id' => t2,
      'points' => 0,
      'matches' => 0,
      'total_matches' => 0,
      'list' => []
    }
  end

  t1_rating = 
  t1_points = 50 + 25*()
end

puts find(rankings, 9)