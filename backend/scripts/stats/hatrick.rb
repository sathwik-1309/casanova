players = Player.all

h = []
players.each do |player|
  balls = Ball.where(bowler_id: player.id)
  w = 0
  balls.each do|ball|
    if ball.wicket_ball
      w += 1
      if w == 3
        h << {
          "player" => Player.find(ball.bowler_id).name,
          "match_id" => ball.match_id
        }
      end
    else
      w = 0
    end
  end

end

h.each do |hatrick|
  puts "#{hatrick['player']} in match #{hatrick['match_id']}"
end