require "#{Dir.pwd}/lib/seed"

Seed.clear_schedule_entries
Seed.preload_schedules
