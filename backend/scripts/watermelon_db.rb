FILE_PATH = "#{Dir.pwd}/_files/seed/watermelon_db.json"

json = {}
tour = Tournament.last
t_json = tour.attributes.slice('id', 'name', 'season', 'ongoing')
json["tournaments"] = [t_json]

squads = tour.squads
json['teams'] = squads.map{|squad| squad.team.attributes.slice('id', 'name', 'abbrevation')}
json['squads'] = squads.map{|squad| squad.attributes.slice('id', 'name', 'abbrevation', 'team_id', 'tournament_id', 'captain_id')}
players = []
squad_players = []
squads.each do |squad|
  players += squad.squad_players.map{|sp| sp.player}
  squad_players += squad.squad_players
end

json['squad_players'] = []

squad_players.each do |sp|
  json['squad_players'] << sp.attributes.slice('player_id', 'squad_id', 'team_id', 'tournament_id')
end

json['players'] = players.map{|player| player.attributes.slice('id', 'name', 'fullname', 'skill', 'batting_hand', 'bowling_hand', 'bowling_style', 'keeper', 'country_team_id')}
File.open(FILE_PATH, 'w') do |file|
  file.write(JSON.pretty_generate(json))
end
puts "done"
