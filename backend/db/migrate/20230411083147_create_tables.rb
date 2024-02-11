class CreateTables < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.json :medals, default: {}
      t.integer :pots_id
      t.integer :mvp_id
      t.integer :most_runs_id
      t.integer :most_wickets_id
      t.integer :season
      t.json :groups, default: []
      t.boolean :ongoing, default: false

      t.timestamps
    end

    create_table :teams do |t|
      t.string :name
      t.string :abbrevation
      t.integer :matches, default: 0
      t.integer :won, default: 0
      t.integer :lost, default: 0
      t.integer :runs, default: 0
      t.integer :wickets, default: 0
      t.integer :runs_conceded, default: 0
      t.integer :wickets_lost, default: 0
      t.timestamps
    end

    create_table :squads do |t|
      t.string :name
      t.string :abbrevation
      t.integer :matches, default: 0
      t.integer :won, default: 0
      t.integer :lost, default: 0
      t.integer :runs, default: 0
      t.integer :wickets, default: 0
      t.integer :runs_conceded, default: 0
      t.integer :wickets_lost, default: 0
      t.belongs_to :tournament, foreign_key: true
      t.belongs_to :team, foreign_key: true
      t.integer :captain_id
      t.integer :keeper_id
      t.float :nrr, default: 0
      t.timestamps
    end

    create_table :players do |t|
      t.string :fullname
      t.string :name
      t.integer :country_team_id
      t.string :skill
      t.string :batting_hand
      t.string :bowling_hand
      t.string :bowling_style
      t.boolean :keeper
      t.json :trophies
      t.integer :csl_team_id
      t.integer :ipl_team_id
      t.integer :born_team_id
      t.timestamps
    end

    create_table :balls do |t|
      t.integer :batsman_id
      t.integer :bowler_id
      t.integer :runs
      t.integer :bow_runs
      t.integer :extras
      t.string :extra_type
      t.float :delivery
      t.boolean :wicket_ball
      t.integer :score
      t.integer :for
      t.string :category
      t.string :ball_color
      t.belongs_to :over, foreign_key: true
      t.belongs_to :inning, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.timestamps
    end

    create_table :overs do |t|
      t.integer :over_no
      t.integer :balls
      t.integer :runs
      t.integer :bow_runs
      t.integer :wickets
      t.integer :wides
      t.integer :no_balls
      t.integer :extras
      t.integer :score
      t.integer :for
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.string :ball_color
      t.integer :bowler_id
      t.belongs_to :inning, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.timestamps
    end

    create_table :innings do |t|
      t.integer :inn_no
      t.float :overs
      t.integer :score
      t.integer :for
      t.integer :wides
      t.integer :no_balls
      t.integer :extras
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.string :ball_color1
      t.string :ball_color2
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.integer :bat_team_id
      t.integer :bow_team_id
      t.timestamps
    end

    create_table :matches do |t|
      t.string :stage
      t.string :venue
      t.integer :win_by_wickets
      t.integer :win_by_runs
      t.string :ball_color1
      t.string :ball_color2
      t.float :pitch
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.integer :wides
      t.integer :no_balls
      t.integer :extras
      t.integer :runs
      t.integer :wickets
      t.belongs_to :tournament, foreign_key: true
      t.integer :inn1_id
      t.integer :inn2_id
      t.integer :winner_id
      t.integer :loser_id
      t.integer :motm_id
      t.integer :toss_id

      t.timestamps
    end

    create_table :wickets do |t|
      t.string :method
      t.belongs_to :ball, foreign_key: true
      t.belongs_to :over, foreign_key: true
      t.belongs_to :inning, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.integer :batsman_id
      t.integer :bowler_id
      t.integer :fielder_id
      t.float :delivery

      t.timestamps
    end

    create_table :scores do |t|
      t.integer :runs
      t.integer :balls
      t.float :sr
      t.integer :position
      t.boolean :not_out
      t.boolean :batted
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.belongs_to :player, foreign_key: true
      t.belongs_to :squad, foreign_key: true
      t.belongs_to :inning, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.timestamps
    end

    create_table :spells do |t|
      t.float :overs
      t.integer :maidens
      t.integer :runs
      t.integer :wickets
      t.float :economy
      t.float :sr
      t.float :avg
      t.integer :wides
      t.integer :no_balls
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.belongs_to :player, foreign_key: true
      t.belongs_to :squad, foreign_key: true
      t.belongs_to :inning, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.timestamps
    end

    create_table :bat_stats do |t|
      t.string :sub_type
      t.integer :matches
      t.integer :innings
      t.integer :runs
      t.integer :balls
      t.float :sr
      t.float :avg
      t.integer :not_outs
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.integer :thirties
      t.integer :fifties
      t.integer :hundreds
      t.float :boundary_p
      t.float :dot_p
      t.belongs_to :player, foreign_key: true
      t.integer :best_id

      t.timestamps
    end

    create_table :ball_stats do |t|
      t.string :sub_type
      t.integer :matches
      t.integer :innings
      t.float :overs
      t.integer :maidens
      t.integer :runs
      t.integer :wickets
      t.float :economy
      t.float :sr
      t.float :avg
      t.integer :wides
      t.integer :no_balls
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.integer :three_wickets
      t.integer :five_wickets
      t.float :boundary_p
      t.float :dot_p
      t.belongs_to :player, foreign_key: true
      t.integer :best_id

      t.timestamps
    end

    create_table :partnerships do |t|
      t.integer :runs
      t.integer :balls
      t.integer :dots
      t.integer :c1
      t.integer :c2
      t.integer :c3
      t.integer :c4
      t.integer :c6
      t.float :sr
      t.integer :for_wicket
      t.boolean :not_out
      t.integer :b1s
      t.integer :b2s
      t.integer :b1b
      t.integer :b2b
      t.belongs_to :inning, foreign_key: true
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.integer :batsman1_id
      t.integer :batsman2_id
      t.integer :bat_team_id
      t.integer :bow_team_id
      t.timestamps
    end

    create_table :performances do |t|
      t.boolean :won
      t.boolean :captain
      t.boolean :keeper
      t.integer :rank_bat_before
      t.integer :rank_bat_after
      t.integer :rank_bow_before
      t.integer :rank_bow_after
      t.integer :rank_all_before
      t.integer :rank_all_after
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
      t.belongs_to :player, foreign_key: true
      t.belongs_to :squad, foreign_key: true
      t.timestamps
    end

    create_table :schedules do |t|
      t.integer :squad1_id
      t.integer :squad2_id
      t.string :venue
      t.string :stage
      t.boolean :completed
      t.integer :order
      t.integer :match_id
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :squad_players do |t|
      t.belongs_to :player, foreign_key: true
      t.belongs_to :squad, foreign_key: true
      t.belongs_to :team, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :milestones do |t|
      t.boolean :in_match
      t.string :ml_type
      t.string :sub_type
      t.json :value
      t.json :previous_value
      t.json :tags
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :milestone_images do |t|
      t.json :image
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :player_rating_images do |t|
      t.string :rformat
      t.string :rtype
      t.json :rating_image
      t.integer :counter
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :player_ratings do |t|
      t.string :rformat
      t.integer :best_bat_rank
      t.integer :best_bat_rank_match
      t.integer :best_bat_rating
      t.integer :best_bat_rating_match
      t.integer :best_ball_rank
      t.integer :best_ball_rank_match
      t.integer :best_ball_rating
      t.integer :best_ball_rating_match
      t.integer :best_all_rank
      t.integer :best_all_rank_match
      t.integer :best_all_rating
      t.integer :best_all_rating_match
      t.belongs_to :player, foreign_key: true
    end

    create_table :player_match_points do |t|
      t.string :rtype
      t.string :rformat
      t.float :points
      t.belongs_to :match, foreign_key: true
      t.belongs_to :player, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :p_leaderboards do |t|
      t.string :rtype
      t.string :rformat
      t.integer :matches
      t.float :highest_rating
      t.belongs_to :match, foreign_key: true
      t.belongs_to :player, foreign_key: true
    end

    create_table :team_match_points do |t|
      t.string :rformat
      t.float :points
      t.belongs_to :match, foreign_key: true
      t.belongs_to :team, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :t_leaderboards do |t|
      t.string :rformat
      t.integer :matches
      t.float :highest_rating
      t.belongs_to :match, foreign_key: true
      t.belongs_to :team, foreign_key: true
    end

    create_table :team_rating_images do |t|
      t.string :rformat
      t.json :rating_image
      t.integer :counter
      t.belongs_to :match, foreign_key: true
      t.belongs_to :tournament, foreign_key: true
    end

    create_table :team_ratings do |t|
      t.string :rformat
      t.integer :best_rank
      t.integer :best_rank_match
      t.integer :best_rating
      t.integer :best_rating_match
      t.belongs_to :team, foreign_key: true
    end

    create_table :current_squads do |t|
      t.json :jan, default: []
      t.json :feb, default: []
      t.json :mar, default: []
      t.json :apr, default: []
      t.json :may, default: []
      t.json :june, default: []
      t.json :july, default: []
      t.json :aug, default: []
      t.json :sept, default: []
      t.json :oct, default: []
      t.json :nov, default: []
      t.json :dec, default: []
    end

  end
end
