json = []
tours = Tournament.all
tours.each do|tour|
  t_json = {}
  t_id = tour.id
  t_json['t_id'] = t_id
  t_matches = []
  matches = Match.where(tournament_id: t_id)
  matches.each do|match|
    hash = {}
    hash['m_id'] = match.id
    if IPL_IDS.include? t_id and match.stage == 'league'
      venue_dict = {
        "bengaluru" => 23,
        "mumbai" => 24,
        "chennai" => 22,
        "hyderabad" => 21,
        "mohali" => 26,
        "delhi" => 27,
        "kolkata" => 28,
        "jaipur" => 25
      }
      home_team_id = venue_dict[match.venue]
      unless home_team_id
        puts "ERROR ❌, home team not found for match #{m_id}"
      end
      squad1 = Squad.find_by(team_id: home_team_id, tournament_id: t_id)
      squad2 = match.winner_id == squad1.id ? Squad.find(match.loser_id) : Squad.find(match.winner_id)
      hash['squad1'] = squad1.abbrevation
      hash['squad2'] = squad2.abbrevation
    else
      hash['squad1'] = match.inn1.bat_team.abbrevation
      hash['squad2'] = match.inn1.bow_team.abbrevation
    end
    hash['venue'] = match.venue
    hash['stage'] = match.stage
    t_matches << hash
  end
  t_json['matches'] = t_matches
  json << t_json
end

File.open(SCHEDULE_JSON_PATH, 'w') do |file|
  file.write(JSON.pretty_generate(json))
end
