require "#{Dir.pwd}/config/environment"
file = File.read(SEED_JSON_PATH + '/dnb_total.json')
data = JSON.parse(file)

puts data.length
# def get(m_id)
#     m = Match.find(m_id)
#     t1 = m.inn1.bat_team_id
#     t2 = m.inn2.bat_team_id
#     s1 = Score.where(inning_id: m.inn1.id).pluck(:player_id)
#     s2 = Score.where(inning_id: m.inn2.id).pluck(:player_id)
#     p1 = Performance.where(match_id: m_id, squad_id: t1).pluck(:player_id)
#     p2 = Performance.where(match_id: m_id, squad_id: t2).pluck(:player_id)
#     puts Squad.find(t1).abbrevation
#     x = p1 - s1
#     x.each do |p_id|
#         print p_id," ", Player.find(p_id).name
#         puts 
#     end
#     puts "missing #{11 - p1.length}"
#     puts
#     puts Squad.find(t2).abbrevation
#     x = p2 - s2
#     x.each do |p_id|
#         print p_id," ", Player.find(p_id).name
#         puts
#     end
#     puts "missing #{11 - p2.length}"
#     puts 
# end

# m_id = 49

# get(m_id)

