Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  scope :match do
    get '/:m_id/summary' => 'match#summary'
    get '/:m_id/:inn_no/scorecard' => 'match#scorecard'
    get '/:m_id/:inn_no/fow' => 'match#fow'
    get '/:m_id/:inn_no/bowling_card' => 'match#bowling_card'
    get '/:m_id/:inn_no/manhatten' => 'match#manhatten'
    get '/:m_id/:inn_no/partnerships' => 'match#partnerships'
    # get '/:m_id/match_box' => 'match#match_box'
  end

  scope :matches do
    get '' => 'match#matches'
  end

  scope :tournament do
    get '/:t_id/points_table' => 'tournament#points_table'
    get '/:t_id/bat_stats' => 'tournament#bat_stats'
    get '/:t_id/ball_stats' => 'tournament#ball_stats'

  end

  scope :player do
    get '/:p_id/bat_stats' => 'player#bat_stats'
    get '/:p_id/ball_stats' => 'player#ball_stats'
  end


end
