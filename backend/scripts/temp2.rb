def get_custom_rr(balls)
  runs = balls.map{|b| b.runs }.sum
  balls_count = balls.length
  rr = Util.get_rr(runs, balls_count)
  return rr
end

matches = Match.all
arr = []
dict = {'y'=>0, 'r'=>0, 'g'=>0, 'z'=>0}
matches.each do |match|
  bc1 = match.ball_color1
  bc2 = match.ball_color2
  if bc1 != bc2
    crr1 = get_custom_rr(match.balls.where(ball_color: bc1)).to_f.round(2)
    crr2 = get_custom_rr(match.balls.where(ball_color: bc2)).to_f.round(2)
    if crr1 > crr2
      arr << [crr1 - crr2, match.id]
    else
      arr << [crr2 - crr1, match.id]
    end
    dict[bc1] = (dict[bc1] + (crr1 - crr2)).round(2)
    dict[bc2] = (dict[bc2] + (crr2 - crr1)).round(2)
  end
end

puts dict
# puts (arr.sum/arr.length).round(2)
puts arr.sort_by{|item| -item[0]}[0]
m_id = 181
puts "y #{get_custom_rr(Ball.where(ball_color: 'y', match_id: m_id)).to_f.round(2)}"
puts "r #{get_custom_rr(Ball.where(ball_color: 'r', match_id: m_id)).to_f.round(2)}"
puts "g #{get_custom_rr(Ball.where(ball_color: 'g', match_id: m_id)).to_f.round(2)}"