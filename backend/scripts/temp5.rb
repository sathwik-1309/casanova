file = File.read(PLAYERS_JSON_PATH)
data = JSON.parse(file)
p_data = []
data.each do|player|
    p_data << []
end

# Write data to the CSV file
CSV.open(PLAYERS_CSV_PATH, 'w') do |csv|
  p_data.each do |row|
    csv << row
  end
end