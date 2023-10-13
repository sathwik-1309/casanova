
TOURNAMENT_NAMES = ['wt20', 'ipl', 'csl']

GEMS_LIST = [35,147,226,55,39,301]

# paths
ROOT_DIR = Dir.pwd
SEED_CSV_PATH = ROOT_DIR + '/_files/seed/csv'
SEED_JSON_PATH = ROOT_DIR + '/_files/seed/json'
NEW_MATCH = ROOT_DIR + '/_files/new.txt'
NEW_MATCH_JSON = ROOT_DIR + '/_files/new.json'
MATCH_JSON_PATH = "#{Dir.pwd}/_files/temp/magic.json"
MATCH_INGEST_JSON_PATH = "#{Dir.pwd}/_files/temp/ingest.json"
MATCH_CSV_PATH = "#{Dir.pwd}/_files/temp/match_data"
PLAYERS_JSON_PATH = "#{Dir.pwd}/_files/static/players.json"
TOURNAMENT_JSON_PATH = "#{Dir.pwd}/_files/static/tournaments.json"
SQUADS_JSON_PATH = "#{Dir.pwd}/_files/static/squads.json"
SCHEDULE_JSON_PATH = "#{Dir.pwd}/_files/static/schedule.json"
TEAM_MEDALS = "#{Dir.pwd}/_files/static/team_medals.json"
ARGS_JSON_PATH = "#{Dir.pwd}/_files/static/match_args"
MATCH_TEXT_FILE_PATH = "#{Dir.pwd}/_files/static/txt"

# vars
NILL = nil
TEAM_NAMES = %w[ind pak aus nz wi sa eng ban afg sl nep zim ire srh csk rcb mi rr pbks dc kkr jan feb mar apr may june july aug sept oct nov dec]
PLAYER_TROPHIES_INIT = {
  "motm" => 0,
  "pots" => 0,
  "mvp" => 0,
  "most_runs" => 0,
  "most_wickets" => 0,
  "gold" => 0,
  "silver" => 0,
  "bronze" => 0,
  "gem" => 0,
}
TC_TOUR_1 = ["ind", "pak", "wi", "sa", "eng", "aus"]
TC_TOUR_2 = []
TC_TOUR_3 = []
TC_TOUR_4 = ["ind", "pak", "aus"]
TC_TOUR_5 = ["ind", "pak", "aus", "nz", "wi"]
TC_TOUR_6 = []
TC_TOUR_7 = ["nz"]

WORM_COLORS = {
  'ind' => '#226bbf',
  'pak' => '#295f2c',
  'aus' => '#ffcd00',
  'nz' => '#0d0d0d',
  'wi' => '#7e293b',
  'sa' => '#00934c',
  'eng' => '#de142c',
  'ban' => '#037145',
  'afg' => '#264dc3',
  'sl' => '#223d64',
  'srh' => '#EE7429',
  'csk' => '#F9CD05',
  'rcb' => '#db0202',
  'mi' => '#004b8d',
  'rr' => '#e73895',
  'pbks' => '#dd1f2c',
  'kxip' => '#dd1f2c',
  'dc' => '#1b93de',
  'kkr' => '#3a225d',
  'jan' => '#db0007',
  'feb' => '#7d0c94',
  'mar' => '#ffd000',
  'apr' => '#ff1491',
  'may' => '#436e1b',
  'june' => '#704504',
  'july' => '#e39df5',
  'aug' => '#125b34',
  'sept' => '#0076b6',
  'oct' => '#a80554',
  'nov' => '#f5970a',
  'dec' => '#21304d',
  "analysis1" => '#4a3754',
  "analysis2" => '#d1b1e0',
}

