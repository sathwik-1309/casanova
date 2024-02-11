
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
TC_TOUR_3 = ["jan", "feb", "mar", "apr", "may", "june", "july", "aug", "sept", "oct", "nov", "dec"]
TC_TOUR_4 = ["ind", "pak", "aus", "sa"]
TC_TOUR_5 = ["ind", "pak", "aus", "nz", "wi", "sa"]
TC_TOUR_6 = ["jan", "feb", "mar", "apr", "may", "june", "july", "aug", "sept", "oct", "nov", "dec"]
TC_TOUR_7 = ["nz", "ban", "eng", "afg"]
TC_TOUR_8 = []

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

# Player ratings
ENABLED_PLAYER_RATING_TOUR_CLASS = ["wt20", "csl"]
RTYPE_BAT = 'bat'
RTYPE_BALL = 'ball'
RTYPE_ALL = 'all'

PR_PERIOD_MAX = 40
PR_PERIOD_MIN = 32
PR_PERIOD_HALF = 16
PR_MIN_INNINGS_PER_HALF = 3

TR_PERIOD_MAX = 50
TR_PERIOD_MIN = 40
TR_PERIOD_HALF = 20
TR_MIN_INNINGS_PER_HALF = 4

PLAYER_RATING_RTYPES = [RTYPE_BAT, RTYPE_BALL, RTYPE_ALL]
MOTM_POINTS = 40
WIN_POINTS = 15
MATCH_WEIGHT = 0.8
INN_WEIGHT = 0.2
MATCH_WEIGHT_BAT = 0.7
INN_WEIGHT_BAT = 0.3
DEFAULT_BATSMAN_RATING = 120
DEFAULT_ALLROUNDER_RATING = 80
DEFAULT_BOWLER_RATING = 10
TEAM_STRENGTH_BAT_AVG = 100
TEAM_STRENGTH_WEIGHTAGE = 0.1
TEAM_STRENGTH_WEIGHTAGE_BAT = 0.2
TEAM_STRENGTH_BOW_AVG = 120
MAX_RANK = 50

W_IE = 0.1
W_ME = 0.7
W_PE = 0.2
WPC = 0.4
