# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_11_083147) do
  create_table "ball_stats", force: :cascade do |t|
    t.string "sub_type"
    t.integer "matches"
    t.integer "innings"
    t.float "overs"
    t.integer "maidens"
    t.integer "runs"
    t.integer "wickets"
    t.float "economy"
    t.float "sr"
    t.float "avg"
    t.integer "wides"
    t.integer "no_balls"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.integer "three_wickets"
    t.integer "five_wickets"
    t.float "boundary_p"
    t.float "dot_p"
    t.integer "player_id"
    t.integer "best_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_ball_stats_on_player_id"
  end

  create_table "balls", force: :cascade do |t|
    t.integer "batsman_id"
    t.integer "bowler_id"
    t.integer "runs"
    t.integer "bow_runs"
    t.integer "extras"
    t.string "extra_type"
    t.float "delivery"
    t.boolean "wicket_ball"
    t.integer "score"
    t.integer "for"
    t.string "category"
    t.string "ball_color"
    t.integer "over_id"
    t.integer "inning_id"
    t.integer "match_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inning_id"], name: "index_balls_on_inning_id"
    t.index ["match_id"], name: "index_balls_on_match_id"
    t.index ["over_id"], name: "index_balls_on_over_id"
    t.index ["tournament_id"], name: "index_balls_on_tournament_id"
  end

  create_table "bat_stats", force: :cascade do |t|
    t.string "sub_type"
    t.integer "matches"
    t.integer "innings"
    t.integer "runs"
    t.integer "balls"
    t.float "sr"
    t.float "avg"
    t.integer "not_outs"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.integer "thirties"
    t.integer "fifties"
    t.integer "hundreds"
    t.float "boundary_p"
    t.float "dot_p"
    t.integer "player_id"
    t.integer "best_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_bat_stats_on_player_id"
  end

  create_table "innings", force: :cascade do |t|
    t.integer "inn_no"
    t.float "overs"
    t.integer "score"
    t.integer "for"
    t.integer "wides"
    t.integer "no_balls"
    t.integer "extras"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.string "ball_color1"
    t.string "ball_color2"
    t.integer "match_id"
    t.integer "tournament_id"
    t.integer "bat_team_id"
    t.integer "bow_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_innings_on_match_id"
    t.index ["tournament_id"], name: "index_innings_on_tournament_id"
  end

  create_table "matches", force: :cascade do |t|
    t.string "stage"
    t.string "venue"
    t.integer "win_by_wickets"
    t.integer "win_by_runs"
    t.string "ball_color1"
    t.string "ball_color2"
    t.float "pitch"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.integer "wides"
    t.integer "no_balls"
    t.integer "extras"
    t.integer "runs"
    t.integer "wickets"
    t.integer "tournament_id"
    t.integer "inn1_id"
    t.integer "inn2_id"
    t.integer "winner_id"
    t.integer "loser_id"
    t.integer "motm_id"
    t.integer "toss_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "milestone_images", force: :cascade do |t|
    t.json "image"
    t.integer "match_id"
    t.integer "tournament_id"
    t.index ["match_id"], name: "index_milestone_images_on_match_id"
    t.index ["tournament_id"], name: "index_milestone_images_on_tournament_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.boolean "in_match"
    t.string "ml_type"
    t.string "sub_type"
    t.json "value"
    t.json "previous_value"
    t.json "tags"
    t.integer "match_id"
    t.integer "tournament_id"
    t.index ["match_id"], name: "index_milestones_on_match_id"
    t.index ["tournament_id"], name: "index_milestones_on_tournament_id"
  end

  create_table "overs", force: :cascade do |t|
    t.integer "over_no"
    t.integer "balls"
    t.integer "runs"
    t.integer "bow_runs"
    t.integer "wickets"
    t.integer "wides"
    t.integer "no_balls"
    t.integer "extras"
    t.integer "score"
    t.integer "for"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.string "ball_color"
    t.integer "bowler_id"
    t.integer "inning_id"
    t.integer "match_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inning_id"], name: "index_overs_on_inning_id"
    t.index ["match_id"], name: "index_overs_on_match_id"
    t.index ["tournament_id"], name: "index_overs_on_tournament_id"
  end

  create_table "partnerships", force: :cascade do |t|
    t.integer "runs"
    t.integer "balls"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.float "sr"
    t.integer "for_wicket"
    t.boolean "not_out"
    t.integer "b1s"
    t.integer "b2s"
    t.integer "b1b"
    t.integer "b2b"
    t.integer "inning_id"
    t.integer "match_id"
    t.integer "tournament_id"
    t.integer "batsman1_id"
    t.integer "batsman2_id"
    t.integer "bat_team_id"
    t.integer "bow_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inning_id"], name: "index_partnerships_on_inning_id"
    t.index ["match_id"], name: "index_partnerships_on_match_id"
    t.index ["tournament_id"], name: "index_partnerships_on_tournament_id"
  end

  create_table "performances", force: :cascade do |t|
    t.boolean "won"
    t.boolean "captain"
    t.boolean "keeper"
    t.integer "match_id"
    t.integer "tournament_id"
    t.integer "player_id"
    t.integer "squad_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_performances_on_match_id"
    t.index ["player_id"], name: "index_performances_on_player_id"
    t.index ["squad_id"], name: "index_performances_on_squad_id"
    t.index ["tournament_id"], name: "index_performances_on_tournament_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "fullname"
    t.string "name"
    t.integer "country_team_id"
    t.string "skill"
    t.string "batting_hand"
    t.string "bowling_hand"
    t.string "bowling_style"
    t.boolean "keeper"
    t.json "trophies"
    t.integer "csl_team_id"
    t.integer "ipl_team_id"
    t.integer "born_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "squad1_id"
    t.integer "squad2_id"
    t.string "venue"
    t.string "stage"
    t.boolean "completed"
    t.integer "order"
    t.integer "match_id"
    t.integer "tournament_id"
    t.index ["tournament_id"], name: "index_schedules_on_tournament_id"
  end

  create_table "scores", force: :cascade do |t|
    t.integer "runs"
    t.integer "balls"
    t.float "sr"
    t.integer "position"
    t.boolean "not_out"
    t.boolean "batted"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.integer "player_id"
    t.integer "squad_id"
    t.integer "inning_id"
    t.integer "match_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inning_id"], name: "index_scores_on_inning_id"
    t.index ["match_id"], name: "index_scores_on_match_id"
    t.index ["player_id"], name: "index_scores_on_player_id"
    t.index ["squad_id"], name: "index_scores_on_squad_id"
    t.index ["tournament_id"], name: "index_scores_on_tournament_id"
  end

  create_table "spells", force: :cascade do |t|
    t.float "overs"
    t.integer "maidens"
    t.integer "runs"
    t.integer "wickets"
    t.float "economy"
    t.float "sr"
    t.float "avg"
    t.integer "wides"
    t.integer "no_balls"
    t.integer "dots"
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c6"
    t.integer "player_id"
    t.integer "squad_id"
    t.integer "inning_id"
    t.integer "match_id"
    t.integer "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inning_id"], name: "index_spells_on_inning_id"
    t.index ["match_id"], name: "index_spells_on_match_id"
    t.index ["player_id"], name: "index_spells_on_player_id"
    t.index ["squad_id"], name: "index_spells_on_squad_id"
    t.index ["tournament_id"], name: "index_spells_on_tournament_id"
  end

  create_table "squad_players", force: :cascade do |t|
    t.integer "player_id"
    t.integer "squad_id"
    t.integer "team_id"
    t.integer "tournament_id"
    t.index ["player_id"], name: "index_squad_players_on_player_id"
    t.index ["squad_id"], name: "index_squad_players_on_squad_id"
    t.index ["team_id"], name: "index_squad_players_on_team_id"
    t.index ["tournament_id"], name: "index_squad_players_on_tournament_id"
  end

  create_table "squads", force: :cascade do |t|
    t.string "name"
    t.string "abbrevation"
    t.integer "matches", default: 0
    t.integer "won", default: 0
    t.integer "lost", default: 0
    t.integer "runs", default: 0
    t.integer "wickets", default: 0
    t.integer "runs_conceded", default: 0
    t.integer "wickets_lost", default: 0
    t.integer "tournament_id"
    t.integer "team_id"
    t.integer "captain_id"
    t.integer "keeper_id"
    t.float "nrr", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_squads_on_team_id"
    t.index ["tournament_id"], name: "index_squads_on_tournament_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "abbrevation"
    t.integer "matches", default: 0
    t.integer "won", default: 0
    t.integer "lost", default: 0
    t.integer "runs", default: 0
    t.integer "wickets", default: 0
    t.integer "runs_conceded", default: 0
    t.integer "wickets_lost", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.json "medals", default: {}
    t.integer "pots_id"
    t.integer "mvp_id"
    t.integer "most_runs_id"
    t.integer "most_wickets_id"
    t.integer "season"
    t.json "groups", default: []
    t.boolean "ongoing", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wickets", force: :cascade do |t|
    t.string "method"
    t.integer "ball_id"
    t.integer "over_id"
    t.integer "inning_id"
    t.integer "match_id"
    t.integer "tournament_id"
    t.integer "batsman_id"
    t.integer "bowler_id"
    t.integer "fielder_id"
    t.float "delivery"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ball_id"], name: "index_wickets_on_ball_id"
    t.index ["inning_id"], name: "index_wickets_on_inning_id"
    t.index ["match_id"], name: "index_wickets_on_match_id"
    t.index ["over_id"], name: "index_wickets_on_over_id"
    t.index ["tournament_id"], name: "index_wickets_on_tournament_id"
  end

  add_foreign_key "ball_stats", "players"
  add_foreign_key "balls", "innings"
  add_foreign_key "balls", "matches"
  add_foreign_key "balls", "overs"
  add_foreign_key "balls", "tournaments"
  add_foreign_key "bat_stats", "players"
  add_foreign_key "innings", "matches"
  add_foreign_key "innings", "tournaments"
  add_foreign_key "matches", "tournaments"
  add_foreign_key "milestone_images", "matches"
  add_foreign_key "milestone_images", "tournaments"
  add_foreign_key "milestones", "matches"
  add_foreign_key "milestones", "tournaments"
  add_foreign_key "overs", "innings"
  add_foreign_key "overs", "matches"
  add_foreign_key "overs", "tournaments"
  add_foreign_key "partnerships", "innings"
  add_foreign_key "partnerships", "matches"
  add_foreign_key "partnerships", "tournaments"
  add_foreign_key "performances", "matches"
  add_foreign_key "performances", "players"
  add_foreign_key "performances", "squads"
  add_foreign_key "performances", "tournaments"
  add_foreign_key "schedules", "tournaments"
  add_foreign_key "scores", "innings"
  add_foreign_key "scores", "matches"
  add_foreign_key "scores", "players"
  add_foreign_key "scores", "squads"
  add_foreign_key "scores", "tournaments"
  add_foreign_key "spells", "innings"
  add_foreign_key "spells", "matches"
  add_foreign_key "spells", "players"
  add_foreign_key "spells", "squads"
  add_foreign_key "spells", "tournaments"
  add_foreign_key "squad_players", "players"
  add_foreign_key "squad_players", "squads"
  add_foreign_key "squad_players", "teams"
  add_foreign_key "squad_players", "tournaments"
  add_foreign_key "squads", "teams"
  add_foreign_key "squads", "tournaments"
  add_foreign_key "wickets", "balls"
  add_foreign_key "wickets", "innings"
  add_foreign_key "wickets", "matches"
  add_foreign_key "wickets", "overs"
  add_foreign_key "wickets", "tournaments"
end
