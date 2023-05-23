require "#{Dir.pwd}/config/environment"
# require "#{Dir.pwd}/lib/util"
X_PATH = "#{Dir.pwd}/static/text"

def extract_players(file)
    players = []
    total = []
    flag = false
    File.foreach(file) do |line|
        if flag
            if line.start_with?("b=")
                flag = false
                total << players
                players = []
            else
                x = line.split("\t")
                if x[1] == "Did not Bat"
                    players << x[0]
                end
            end
        else
            if line.start_with?("bl1=")
                flag = true  
            end
        end
    end
    return total
end

def rearrange(dnb)
    ret = []
    bat = []
    all = []
    bow = []
    dnb.each do |list|
        p_id = list[0]
        if Player.find(p_id).skill == "bat"
            bat << p_id 
        end
    end

    dnb.each do |list|
        p_id = list[0]
        if Player.find(p_id).skill == "all"
            all << p_id 
        end
    end

    dnb.each do |list|
        p_id = list[0]
        if Player.find(p_id).skill == "bow"
            bow << p_id 
        end
    end

    return bat + all + bow
end

total = {}
Dir.glob("#{X_PATH}/*").each do |file|
    matches = []
    m_id, team1, team2 = File.basename(file, '').split('_')
    print [ m_id, team1, team2]
    names = extract_players(file)
    dnb = []
    names[0].each do |name|
        p_id = Util.get_pid(name.downcase)
        if p_id.nil?
            puts "error. #{name} for team #{team1}"
        else
            p = Performance.where(player_id: p_id, tournament_id: 3)
            if p.length == 0
                puts "performance not found for #{p_id}, #{name} from #{team}"
            end
            dnb << [p_id, name]
        end
        
    end
    matches << rearrange(dnb)
    batted = Score.where(inning_id: ((2*(m_id.to_i)) - 1)).length
    if batted + dnb.length != 11
        puts "length error. #{batted + dnb.length} for match #{m_id}, inn 1"
    end

    dnb = []
    names[1].each do |name|
        p_id = Util.get_pid(name.downcase)
        if p_id.nil?
            puts "error. #{name} for team #{team1}"
        else
            p = Performance.where(player_id: p_id, tournament_id: 3)
            if p.length == 0
                puts "performance not found for #{p_id}, #{name} from #{team}"
            end
            dnb << [p_id, name]
        end
    end
    matches << rearrange(dnb)
    batted = Score.where(inning_id: (2*(m_id.to_i))).length
    if batted + dnb.length != 11
        puts ""
        puts "length error. #{batted + dnb.length} for match #{m_id}, inn 2 ❌"
    end
    total[m_id] = matches
end

File.open(SEED_JSON_PATH + "/dnb.json", 'w') do |file|
    file.write(JSON.pretty_generate(total))
end


