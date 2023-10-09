def generate_new_schedule(matches, decided, venues, teams, max_per_venue, min_num_venues)
  schedule = []
  played_in = {}
  empty_venues = {}
  invalid = []
  total_invalid = []
  teams_length = teams.length
  matches.each do |match|
    invalid << []
    total_invalid << []
  end
  venues_list = []
  venues.keys.each do |venue|
    empty_venues[venue] = 0
    venues_list << venue
  end
  total_venues = venues_list.length
  teams.each do |team|
    played_in[team] = empty_venues.dup
  end
  decided.each do |match|
    venues[match['venue']] -= 1
    played_in[match['teams'][0]][match['venue']] += 1
    played_in[match['teams'][1]][match['venue']] += 1
  end
  match_venues = {}
  i = 0
  while i < matches.length
    if invalid[i].length == total_venues
      i -= 1
    end
    temp_venue = get_venue(invalid, i, venues_list)
    if check(venues, max_per_venue, played_in, matches[i][0], matches[i][1], temp_venue, min_num_venues, teams_length)
      schedule << {
        'teams' => matches[i],
        'venue' => temp_venue
      }
      venues[temp_venue] -= 1
      played_in[matches[i][0]][temp_venue] += 1
      played_in[matches[i][1]][temp_venue] += 1
      i += 1
    else
      invalid[i] << temp_venue
      if invalid[i].length == total_venues
        invalid[i] = []
        invalid[i-1] += [schedule[i-1]['venue']]
        del_match = schedule.pop
        venues[del_match['venue']] += 1
        played_in[del_match['teams'][0]][temp_venue] -= 1
        played_in[del_match['teams'][1]][temp_venue] -= 1
        i -= 1
      end
    end
    if i == 0
      puts "Combination not possible"
      return
    end
  end
  ans = {}
  decided.each do |game|
    schedule << game
  end
  teams.each do |team|
    v = {}
    schedule.each do |game|
      if game['teams'].include? team
        v[game['venue']] = 0 unless v.has_key? game['venue']
        v[game['venue']] += 1
      end
    end
    ans[team] = v
  end
  puts schedule
  puts ans
  new={}
  ans.keys.each do|team|
    new[team] = ans[team].keys.length
  end
  puts new
end

def get_venue(invalid, i, venues_list)
  return (venues_list - invalid[i]).sample
end

def check(venues, max_per_venue, played_in, team1, team2, temp_venue, min_num_venues, teams_length)
  return false if venues[temp_venue] == 0
  return false if played_in[team1][temp_venue] == max_per_venue
  return false if played_in[team2][temp_venue] == max_per_venue
  tot_matches = 0
  tot_venues = 0
  played_in[team1].keys.each do |venue|
    tot_matches += played_in[team1][venue]
    tot_venues += 1 if played_in[team1][venue] > 0
  end
  return false if tot_matches == (teams_length-2) and tot_venues < min_num_venues
  tot_matches = 0
  tot_venues = 0
  played_in[team2].keys.each do |venue|
    tot_matches += played_in[team2][venue]
    tot_venues += 1 if played_in[team2][venue] > 0
  end
  return false if tot_matches == (teams_length-2) and tot_venues < min_num_venues
  return true
end

teams = ['ind', 'aus', 'pak', 'sl', 'afg', 'ban', 'eng', 'nz', 'sa']
venues = { 'Bengaluru' => 4, 'Mumbai' => 3, 'Kolkata' => 3, "Delhi" => 4, "Ahmedabad" => 4, "Chennai" => 4, "Dharamshala" => 4, "Pune" => 4, "Hyderabad" => 3, "Lucknow" => 3 }
matches = []
shuffled_matches = matches.shuffle
decided = []
#generate_new_schedule(shuffled_matches, decided, venues, teams, 2, 5)
schedule = [
  {
    "teams": [
      "aus",
      "eng"
    ],
    "venue": "Kolkata"
  },
  {
    "teams": [
      "pak",
      "ban"
    ],
    "venue": "Kolkata"
  },
  {
    "teams": [
      "aus",
      "sa"
    ],
    "venue": "Dharamshala"
  },
  {
    "teams": [
      "sl",
      "eng"
    ],
    "venue": "Mumbai"
  },
  {
    "teams": [
      "sl",
      "aus"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "nz",
      "afg"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "pak",
      "sa"
    ],
    "venue": "Mumbai"
  },
  {
    "teams": [
      "nz",
      "eng"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "aus",
      "afg"
    ],
    "venue": "Pune"
  },
  {
    "teams": [
      "ban",
      "eng"
    ],
    "venue": "Hyderabad"
  },
  {
    "teams": [
      "afg",
      "ban"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "pak",
      "aus"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "sl",
      "nz"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "nz",
      "sa"
    ],
    "venue": "Pune"
  },
  {
    "teams": [
      "nz",
      "ban"
    ],
    "venue": "Lucknow"
  },
  {
    "teams": [
      "afg",
      "eng"
    ],
    "venue": "Lucknow"
  },
  {
    "teams": [
      "sl",
      "sa"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "sa",
      "eng"
    ],
    "venue": "Delhi"
  },
  {
    "teams": [
      "pak",
      "afg"
    ],
    "venue": "Lucknow"
  },
  {
    "teams": [
      "sa",
      "ban"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "sl",
      "afg"
    ],
    "venue": "Dharamshala"
  },
  {
    "teams": [
      "sl",
      "ban"
    ],
    "venue": "Pune"
  },
  {
    "teams": [
      "pak",
      "nz"
    ],
    "venue": "Hyderabad"
  },
  {
    "teams": [
      "pak",
      "sl"
    ],
    "venue": "Hyderabad"
  },
  {
    "teams": [
      "aus",
      "nz"
    ],
    "venue": "Delhi"
  },
  {
    "teams": [
      "pak",
      "eng"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "aus",
      "ban"
    ],
    "venue": "Dharamshala"
  },
  {
    "teams": [
      "sa",
      "afg"
    ],
    "venue": "Delhi"
  },
  {
    "teams": [
      "ind",
      "pak"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "ind",
      "ban"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "ind",
      "eng"
    ],
    "venue": "Mumbai"
  },
  {
    "teams": [
      "ind",
      "sl"
    ],
    "venue": "Kolkata"
  },
  {
    "teams": [
      "ind",
      "aus"
    ],
    "venue": "Delhi"
  },
  {
    "teams": [
      "ind",
      "nz"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "ind",
      "afg"
    ],
    "venue": "Pune"
  },
  {
    "teams": [
      "ind",
      "sa"
    ],
    "venue": "Dharamshala"
  }
]

fixed = [
  {
    "teams": [
      "aus",
      "nz"
    ],
    "venue": "Delhi"
  },
  {
    "teams": [
      "ind",
      "sa"
    ],
    "venue": "Dharamshala"
  },
  {
    "teams": [
      "sl",
      "eng"
    ],
    "venue": "Mumbai"
  },
  {
    "teams": [
      "pak",
      "ban"
    ],
    "venue": "Kolkata"
  },


  {
    "teams": [
      "ind",
      "afg"
    ],
    "venue": "Pune"
  },
  {
    "teams": [
      "pak",
      "sl"
    ],
    "venue": "Hyderabad"
  },
  {
    "teams": [
      "sa",
      "ban"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "aus",
      "eng"
    ],
    "venue": "Kolkata"
  },


  {
    "teams": [
      "sl",
      "ban"
    ],
    "venue": "Pune"
  },
  {
    "teams": [
      "nz",
      "afg"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "pak",
      "sa"
    ],
    "venue": "Mumbai"
  },
  {
    "teams": [
      "ind",
      "aus"
    ],
    "venue": "Delhi"
  },


  {
    "teams": [
      "pak",
      "afg"
    ],
    "venue": "Lucknow"
  },
  {
    "teams": [
      "sa",
      "eng"
    ],
    "venue": "Delhi"
  },
  {
    "teams": [
      "sl",
      "aus"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "nz",
      "ban"
    ],
    "venue": "Lucknow"
  },


  {
    "teams": [
      "ind",
      "pak"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "afg",
      "eng"
    ],
    "venue": "Lucknow"
  },
  {
    "teams": [
      "nz",
      "sa"
    ],
    "venue": "Pune"
  },
  {
    "teams": [
      "aus",
      "ban"
    ],
    "venue": "Dharamshala"
  },


  {
    "teams": [
      "ind",
      "eng"
    ],
    "venue": "Mumbai"
  },
  {
    "teams": [
      "sl",
      "sa"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "pak",
      "nz"
    ],
    "venue": "Hyderabad"
  },
  {
    "teams": [
      "aus",
      "afg"
    ],
    "venue": "Pune"
  },


  {
    "teams": [
      "ind",
      "sl"
    ],
    "venue": "Kolkata"
  },
  {
    "teams": [
      "nz",
      "eng"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "afg",
      "ban"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "aus",
      "sa"
    ],
    "venue": "Dharamshala"
  },


  {
    "teams": [
      "ind",
      "nz"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "pak",
      "aus"
    ],
    "venue": "Ahmedabad"
  },
  {
    "teams": [
      "sl",
      "afg"
    ],
    "venue": "Dharamshala"
  },
  {
    "teams": [
      "ban",
      "eng"
    ],
    "venue": "Hyderabad"
  },


  {
    "teams": [
      "ind",
      "ban"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "pak",
      "eng"
    ],
    "venue": "Chennai"
  },
  {
    "teams": [
      "sl",
      "nz"
    ],
    "venue": "Bengaluru"
  },
  {
    "teams": [
      "sa",
      "afg"
    ],
    "venue": "Delhi"
  }
]
games = {}
pp = {}
puts fixed.select { |s| s[:teams].include? 'eng' }







