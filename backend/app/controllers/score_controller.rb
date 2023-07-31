class ScoreController < ApplicationController
  def score
    hash = {}
    score = Score.find(params[:id])
    hash['score_box'] = score.score_box
    # hash['phase_box'] = score.phase_box

    render(:json => Oj.dump(hash))
  end
end
