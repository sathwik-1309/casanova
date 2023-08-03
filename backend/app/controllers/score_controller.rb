class ScoreController < ApplicationController
  def score
    hash = {}
    score = Score.find(params[:id])
    hash['score_box'] = score.score_box
    balls = Ball.where(batsman_id: score.player_id, inning_id: score.inning_id)
    hash['phase_box'] = score.phase_box(balls)
    hash['vs_bowlers'] = score.vs_bowlers(balls)
    render(:json => Oj.dump(hash))
  end
end
