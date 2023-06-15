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
    get '/:t_id' => 'tournament#tournament_home'
  end

  scope :tournaments do
    get '/:tour_class' => 'tournament#tournaments_home'
  end


  scope :player do
    get '/:p_id/bat_stats' => 'player#bat_stats'
    get '/:p_id/ball_stats' => 'player#ball_stats'
  end

  scope :players do
    get '' => 'player#players'
    get '/batting_meta' => 'player#batting_meta'
    get '/bowling_meta' => 'player#bowling_meta'
  end

  scope :teams do
    get '' => 'team#teams'
  end

  scope :venues do
    get '' => 'venue#venues'
  end

  get 'home_page' => 'tournament#home_page'


end
