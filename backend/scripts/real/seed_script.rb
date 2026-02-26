directory_path = REAL_IPL_JSONS + "/2008"

json_files = Dir.glob(File.join(directory_path, '*.json')).sort

json_files.each do |file|
  # Open and read the JSON file
  begin
    json_data = File.read(file)
    # Parse the JSON data
    parsed_data = JSON.parse(json_data)
    
    # Do something with the parsed data
    puts "Processing IPL #{parsed_data['info']['dates'][0].split("-")[0]} - match #{parsed_data['info']['event']['match_number'] || parsed_data['info']['event']['stage']}"
    
  rescue JSON::ParserError => e
    puts "Error parsing JSON file #{file}: #{e.message}"
  end
end