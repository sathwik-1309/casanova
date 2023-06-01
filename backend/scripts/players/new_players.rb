require_relative "#{Dir.pwd}/config/environment"

file = File.read(PLAYERS_JSON_PATH)
data = JSON.parse(file)
latest_pid = Player.last.id
data.each do |player|
  p_id = player["id"]
  if p_id > latest_pid
    p = Player.new
    p.id = p_id
    p.fullname = player["fullname"]
    p.name = player["name"]
    p.country_team_id = player["country"]
    p.skill = player["skillset"][0]
    p.batting_hand = player["skillset"][1]
    p.bowling_hand = player["skillset"][2]
    p.bowling_style = player["skillset"][3]
    p.keeper = player["keeper"]
    p.motms = 0
    p.pots = 0
    p.mvps = 0
    p.gems = 0
    p.most_wickets = 0
    p.most_runs = 0
    p.winners = 0
    p.runners = 0
    p.csl_team_id = player["csl"]
    p.ipl_team_id = player["ipl"]
    p.born_team_id = player["born"]
    unless p.save
      puts "Player add error ❌"
    else
      puts "Player added ✅, #{p_id}"
    end

  end
end
