def get_mvp(t_id)
  players = Player.all
  mvp = []
  players.each do|player|
    p_id = player.id
    points = player.get_tour_mvp_points(t_id)
    mvp << {
      "p_id" => p_id,
      "points" => points
    }
  end
  mvp = mvp.sort_by { |hash| -hash["points"] }
  puts mvp[..4]
end

def motm(m_id)
  scores = Score.where(match_id: m_id)
  statements = []
  max_points = 0
  motm = nil
  scores.each do|score|
    p_id = score.player_id
    p = Player.find(p_id)
    points = p.get_mvp_points(m_id)
    if points > max_points
      motm = p_id
      max_points = points
    end
  end
  return motm
end

def mvp(m_id)
  scores = Score.where(match_id: m_id)
  statements = []
  scores.each do|score|
    p_id = score.player_id
    p = Player.find(p_id)
    points = p.get_mvp_points(m_id)
    statements << [points, "#{p.name}: #{points}"]
  end
  statements = statements.sort_by { |sub_array| -sub_array[0] }
  statements.each do |statement|
    puts statement[1]
  end
end

def get_mvp_tid(t_id)
  scores = Score.where(tournament_id: t_id)
  points_hash = {}
  scores.each do|score|
    p_id = score.player_id
    p = Player.find(p_id)
    points = p.get_mvp_points(score.match_id)
    if points_hash[p_id]
      points_hash[p_id] += points
    else
      points_hash[p_id] = points
    end
  end
  points_hash
end

# matches = Match.all
# matches.each do|match|
#   m_id = match.id
#   if motm(m_id) != match.motm_id
#     puts "#{m_id}: #{Player.find(motm(m_id)).name} , #{Player.find(match.motm_id).name}"
#   end
# end

points = get_mvp_tid(7)
points = points.sort_by { |key, value| -value }
points = points[..6]

# Output the sorted hash
points.each { |key, value| puts "#{Player.find(key).name}: #{value}" }
