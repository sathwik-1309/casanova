nov = [345, 240, 324, 221]
sept = [328, 221, 342, 240]
july = [351, 240, 358, 240]
pak = [1188, 826, 1229, 839]
pak2 = [1383, 946, 1389, 959]

afg3 = [1384, 954, 1323, 960]

def nrr(list)
  nrr = (list[0]*6/list[1].to_f) - (list[2]*6/list[3].to_f)
  puts nrr.round(2)
end

nrr(sept)
nrr(nov)
nrr(july)
def highest_chased(matches)
  chased = []
  defended = []
  matches.each do |match|
    if match.winner_id == match.inn1.bat_team_id
      defended << {'id'=>match.id, 'score'=>match.inn1.score}
    else
      chased << {'id'=>match.id, 'score'=>match.inn1.score}
    end
  end
  defended = defended.sort_by{|m| m['score']}
  chased = chased.sort_by{|m| - m['score']}
  puts defended[..3]
  puts "--------"
  puts chased[..3]
end

# highest_chased(Match.where(tournament_id: 7))
x=CurrentSquad.first
players=x.jan+x.feb+x.mar+x.apr+x.may+x.june+x.july+x.aug+x.sept+x.oct+x.nov+x.dec
dict={}
Player.where(id: players).each do |player|
  born = player.born_team_id
  if dict.has_key? born
    dict[born] += 1
  else
    dict[born] = 1
  end
end

# [[sept, 19], [dec, 19], [oct, 18], [june, 14],
#  [feb, 11], [mar, 11], [nov, 11], [jan, 11], 
#  [july, 10], [may, 10], [apr, 9], [aug, 9]]

# x=dict.sort_by{|k,v| -v }
# print x

# A
# dec
# oct
# aug

# B
# sept
# nov
# july

# C
# jan
# feb
# apr

# D
# june
# mar
# may

# injured = [[brook, iftikhar], [pathirana, haider ali], [ruturaj, mosaddek], [surya, parthiv]]

# july win by 25-26 runs, they top, sept go through
# july win by 35 runs, sept out
# july win by 16 runs, they go through, sept top
