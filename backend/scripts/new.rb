require "#{Dir.pwd}/lib/new"

file = File.read(NEW_MATCH_JSON)
args = JSON.parse(file)

New.upload_match(args)

