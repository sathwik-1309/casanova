module New
  def self.create_json_file(m_id, args)
    File.open(ARGS_JSON_PATH + "/#{m_id}.json", 'w') do |file|
      file.write(JSON.pretty_generate(args))
    end
  end

  def self.upload_match(args, existing = true, textfile = NEW_MATCH)
    m_id = args["m_id"]
    # latest_m_id = Match.last.id
    # if latest_m_id + 1 != m_id
    #   puts "❌ m_id is not latest: #{m_id}, latest m_id: #{latest_m_id}"
    # end
    status = Magic.validate_match_list(m_id, textfile)
    i = Ingest.new(args)
    unless i.status
      puts "Ingest not generated ❌"
      return false
    end
    status = Validator.validate_match
    raise StandardError, "Validator.validate_match failed" unless status
    # status = Validator.check_schedule_entry(args)
    # raise StandardError, "Validator.check_schedule_entry failed" unless status
    status = Uploader.upload_match
    raise StandardError, "Uploader.upload_match failed" unless status
    if existing
      New.create_json_file(m_id, args)
      New.copy_text_file(NEW_MATCH, m_id)
    end
  end

  def self.copy_text_file(source_path, m_id)
    destination_path = MATCH_TEXT_FILE_PATH + "/#{m_id}.txt"
    # Read the content of the source file
    content = File.read(source_path)

    # Write the content to the destination file
    File.open(destination_path, 'w') do |file|
      file.write(content)
    end

    # puts "File copied successfully from '#{source_path}' to '#{destination_path}'."
  rescue Errno::ENOENT
    puts "File '#{source_path}' does not exist."
  rescue Errno::EACCES
    puts "Permission denied. Unable to copy file from '#{source_path}' to '#{destination_path}'."
  end

  def self.add_existing_matches_to_db
    input_path = ARGS_JSON_PATH
    existing_matches = []
    Dir.foreach(input_path) do |filename|
      next if filename == '.' || filename == '..'  # Skip current directory and parent directory
      m_id = filename.split(".")[0]
      existing_matches << [filename, m_id.to_i]
    end
    sorted_array = existing_matches.sort_by { |array| array[1] }
    sorted_array.each do |array|
      filename = array[0]
      m_id = array[1]
      file = File.read(ARGS_JSON_PATH + '/' + filename)
      args = JSON.parse(file)
      New.upload_match(args, false , MATCH_TEXT_FILE_PATH + "/#{m_id}.txt")
    end
  rescue Errno::ENOENT
    puts "Directory '#{input_path}' does not exist."
  rescue Errno::EACCES
    puts "Permission denied. Unable to access directory '#{input_path}'."
  end
end
