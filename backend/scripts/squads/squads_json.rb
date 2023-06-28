json = []
tours = Tournament.all
tours.each do|tour|
  t_id = tour.id
  t_json = {}
  t_json['t_id'] = t_id
  squads = Squad.where(tournament_id: t_id)
  t_squads = []
  squads.each do|squad|
    hash = {}
    hash['squad_id'] = squad.id
    hash['team_id'] = squad.team_id
    hash['name'] = squad.name
    hash['abbrevation'] = squad.abbrevation
    hash['captain_id'] = squad.captain_id
    hash['keeper_id'] = squad.keeper_id
    hash['players'] = squad.get_players.pluck(:id)
    t_squads << hash
  end
  t_json['squads'] = t_squads
  json << t_json
end

File.open(SQUADS_JSON_PATH, 'w') do |file|
  file.write(JSON.pretty_generate(json))
end

