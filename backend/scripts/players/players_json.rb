# create players json in entries

require_relative "#{Dir.pwd}/config/environment"

players = Player.all
p_hash = []
players.each do|player|
    hash = {}
    id = player.id
    csv_file = File.read(SEED_CSV_PATH + 'players_name.csv')
    csv_data = CSV.parse(csv_file)
    line = csv_data[id-1]
    hash["id"] = id
    hash["fullname"] = player.fullname
    hash["name"] = player.name
    hash["skillset"] = [player.skill, player.batting_hand, player.bowling_hand, player.bowling_style]
    hash["keeper"] = player.keeper
    hash["country"] = player.country_team_id
    hash["ipl"] = player.ipl_team_id
    hash["csl"] = player.csl_team_id
    hash["names"] = line[1..-4]
    csv_file = File.read("#{Dir.pwd}/lib/scripts/players/born.csv")
    csv_data = CSV.parse(csv_file)
    line = csv_data[id-1]
    born = line[0]
    born = Team.find_by(abbrevation: born).id
    hash["born"] = born
    # player.born_team_id = born
    # player.save
    p_hash.append(hash)
end
# File.open(PLAYERS_JSON_PATH, 'w') do |file|
#     file.write(JSON.pretty_generate(p_hash))
# end
