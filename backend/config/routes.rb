Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/bat_stats' => 'tournament#overall_bat_stats'
  get '/ball_stats' => 'tournament#overall_ball_stats'
  
  scope :match do
    get '/:m_id/summary' => 'match#summary'
    get '/:m_id/:inn_no/scorecard' => 'match#scorecard'
    get '/:m_id/:inn_no/fow' => 'match#fow'
    get '/:m_id/:inn_no/bowling_card' => 'match#bowling_card'
    get '/:m_id/:inn_no/manhatten' => 'match#manhatten'
    get '/:m_id/:inn_no/partnerships' => 'match#partnerships'
    get '/:m_id/worm' => 'match#worm'
    get '/:m_id/:inn_no/commentry' => 'match#commentry'
    get '/:m_id/innings_progression' => 'match#innings_progression'
    get '/:m_id/player_rankings' => 'match#player_rankings'
    get '/:m_id/team_rankings' => 'match#team_rankings'
    get '/:m_id/player_rankings_list' => 'match#player_rankings_list'
    # get '/:m_id/match_box' => 'match#match_box'
  end

  scope :matches do
    get '' => 'match#matches'
  end

  scope :tournament do
    post '/create' => 'tournament#create'
    post '/create_file' => 'tournament#create_file'
    get '/list' => 'tournament#list'
    delete '/delete' => 'tournament#delete'
    get '/:t_id/points_table' => 'tournament#points_table'
    get '/:t_id/bat_stats' => 'tournament#bat_stats'
    get '/:t_id/ball_stats' => 'tournament#ball_stats'
    get '/:t_id' => 'tournament#tournament_home'
    get '/:t_id/schedule' => 'tournament#schedule'
    get '/:t_id/knockouts' => 'tournament#knockouts'
  end

  scope :tournaments do
    get '/:tour_class' => 'tournament#tournaments_home'
    get '/:tour_class/bat_stats' => 'tournament#tour_class_bat_stats'
    get '/:tour_class/ball_stats' => 'tournament#tour_class_ball_stats'
  end

  scope :search do
    get '/player' => 'player#search'
  end


  scope :player do
    get '/leaderboard' => 'player#leaderboard'
    get '/:p_id/bat_stats' => 'player#bat_stats'
    get '/:p_id/bat_stats2' => 'player#bat_stats2'
    get '/:p_id/ball_stats' => 'player#ball_stats'
    get '/:p_id/ball_stats2' => 'player#ball_stats2'
    get '/:p_id/scores' => 'player#scores'
    get '/:p_id/spells' => 'player#spells'
    get '/:p_id/bowling_analysis' => 'player#bowling_analysis'
    get '/:p_id' => 'player#home_page'
    post '/create' => 'player#create'
  end

  scope :players do
    get '' => 'player#players'
    get '/batting_meta' => 'player#batting_meta'
    get '/bowling_meta' => 'player#bowling_meta'
  end

  scope :teams do
    get '' => 'team#teams'
    get '/player_create' => 'team#player_create'
    get '/:team_id/team_page' => 'team#team_page'
    get '/head_to_head' => 'team#head_to_head'
    get '/head_to_head_detailed' => 'team#head_to_head_detailed'
    get '/leaderboard' => 'team#leaderboard'
    get '/select_squads/:team_id' => 'team#select_squads'
    get '/select_squads' => 'team#select_squads_home'
    put '/:team_id/select_squads_action' => 'team#select_squads_action'
  end

  scope :venues do
    get '' => 'venue#venues'
  end

  scope :score do
    get '/:id' => 'score#score'
  end

  scope :spell do
    get '/:id' => 'spell#spell'
  end

  scope :squads do
    get '' => 'team#squads'
    get '/:squad_id/squad_page' => 'squad#squad_page'
  end

  scope :schedule do
    post '/upload_file' => 'schedule#upload_file'
    get '/pre_match' => 'schedule#pre_match'
    get '/pre_match_squads' => 'schedule#pre_match_squads'
  end

  get 'home_page' => 'tournament#home_page'
  get 'images/:filename', to: 'image#show', as: :uploaded_image


end
