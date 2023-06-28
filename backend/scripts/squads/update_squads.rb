require "#{Dir.pwd}/lib/seed"

# add new squads
Seed.add_new_squads

# clears and preloads squad_player entries in db
Seed.update_squad_players

