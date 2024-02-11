require "#{Dir.pwd}/lib/seed"

Seed.add_tournaments

Seed.add_teams

Seed.add_squads

Seed.add_new_players
# Seed.update_players
# Seed.update_players_keeper
# Seed.update_players_born

Seed.add_matches

Seed.add_innings

Seed.add_overs

Seed.add_balls

Seed.update_overs

Seed.add_scores
Seed.add_playing_11_scores

Seed.add_spells

Seed.add_wickets

# added in hooks
# Seed.add_bat_stats
# Seed.add_new_players_batstats

# Seed.add_ball_stats
# Seed.add_new_players_ballstats

Seed.add_partnerships

Seed.add_performances
Seed.add_playing_11_performances

# Seed.update_tournaments

Seed.preload_squad_players
# Seed.preload_schedules

Seed.update_matches

Seed.update_squads

Seed.update_teams

# add new squads
Seed.add_new_squads
# clears and preloads squad_player entries in db
Seed.update_squad_players

Seed.add_current_squads_entry

# Seed.add_existing_matches
