# require_relative "#{Dir.pwd}/config/environment"
# require "#{Dir.pwd}/lib/util"
module Magic

    def self.read_file(file_path)
        lines = []
        File.foreach(file_path) do |line|
          lines << line.chomp.split(" ")
        end
        return lines
    end

    def self.get_batting_card_index(list)
        index = 0
        flag = true
        batsmen_found = false
        while flag and index < list.length
            if batsmen_found
                if list[index][0]=='First' or list[index][0]=='Second'
                    flag = false
                    end_index = index - 2
                end

            else
                if list[index]==['SR']
                    batsmen_found = true
                    start_index = index + 2
                end
            end
            index += 1
        end
        return start_index, end_index
    end

    def self.get_bowling_card_index(list)
        index = 0
        flag = true
        batsmen_found = false
        while flag and index < list.length
            if batsmen_found
                if list[index][0]=='Result:' or list[index][0]=='Second'
                    flag = false
                    end_index = index - 2
                end

            else
                if list[index]==['Runs','Wkts','Per','Ball','Score']
                    batsmen_found = true
                    start_index = index + 2
                end
            end
            index += 1
        end
        return start_index, end_index
    end

    def self.get_spells_index(list)
        index = 0
        flag = true
        bowler_found = false
        while flag and index < list.length
            if bowler_found
                if list[index][1] == 'Innings-Fall'
                    flag = false
                    end_index = index - 2
                end

            else
                if list[index][1] == 'Innings-Bowling'
                    bowler_found = true
                    start_index = index + 19
                end
            end
            index += 1
        end
        return start_index, end_index
    end

    def self.get_team_score_index(list)
        flag = true
        index = 0
        while flag and index < list.length
            if list[index][1] == "Innings-Batting"
                flag = false
                score_index = index - 2
                over_index = index + 1
                extras_index = index + 2
            end
            index += 1
        end
        if flag
            puts "#Magic failed ❌"
            return
        end
        temp = list[score_index][0].split(":")
        print temp
        team = temp[0]
        team_id = Team.find_by(abbrevation: team.downcase).id
        if team_id.nil?
            puts "#Magic team not found #{team} ❌"
        end
        
        runs = temp[1].split("/")[0]
        wickets = temp[1].split("/")[1]
        overs = list[over_index][0].split(":")[1]
        extras = list[extras_index]
        total_extras = extras[1].split("(")[0]
        wides = extras[4].split(":")[1][0]
        nbs = extras[3].split(":")[1]
        lbs = extras[2].split(":")[1]
        byes = extras[1].split(":")[1]
        extra_hash = {
            "total_extras": total_extras,
            "wides": wides,
            "no_balls": nbs,
            "lbs": lbs,
            "byes": byes
        }
        return {
            "team": team_id,
            "score": runs,
            "for": wickets,
            "overs": overs,
            "extras": extra_hash
        }
    end

    def self.join_arrays2(list)
        ret_list = []
        i = 0
        while i<(list.length-1)
            if list[i]!=[] and list[i+1]!=[]
                temp = list[i] + list[i+1]
                ret_list.append(temp)
                i += 1
            else
                ret_list.append(list[i])
            end
            i += 1
        end
        return ret_list.reject!(&:empty?)
    end

    def self.create_batsmen_hash(list, team_id)
        hash = []
        i = 0
        method = []
        while i<list.length
            if i%8==0
                name = list[i].join(" ")
            elsif i%8==1
                # if method.exclude? list[i][0]
                #     method.append(list[i][0])
                # end
                not_out = false
                batted = true
                out_method = nil
                fielder = nil
                bowler = nil
                if list[i][0]=="Did"
                    batted = false
                elsif list[i][0]=="not"
                    not_out = true
                else
                    out_method = list[i][0]
                    if list[i][0]=="c" or list[i][0]=="st"
                        j = 1
                        flag2 = true
                        temp2 = []
                        while flag2 and j<list[i].length
                            if list[i][j] == "b"
                                flag2 = false
                                fielder = temp2.join(" ").downcase
                            else
                                temp2.append(list[i][j])
                            end
                            j += 1
                        end
                    end
                    j = list[i].length
                    temp3 = []
                    flag3 = true
                    while flag3 and j>0
                        if list[i][j]=="b"
                            flag3 = false
                        else
                            temp3.append(list[i][j])
                        end
                        j-=1
                    end
                    bowler = temp3.reverse.join(" ").strip.downcase
                end
            elsif i%8==2
                runs = list[i][0].to_i
            elsif i%8==3
                balls = list[i][0].to_i
                hash.append({"name": name.downcase, "method": out_method, "not_out": not_out, "batted": batted, "fielder": fielder, "runs": runs, "balls": balls, "bowler": bowler })
            end
            i += 1
        end
        ret = []
        sorting = []
        hash.each do |bat|
            if bat[:batted]
                ret << bat
            else
                sorting << [Util.get_pid_team(bat[:name], team_id), bat[:name]]
            end
        end
        rearraged = Magic.rearrange(sorting)
        rearraged.each do |list|
            ret << {
                "name": list[1],
                "method": nil,
                "not_out": false,
                "batted": false,
                "fielder": nil,
                "runs": 0,
                "balls": 0,
                "bowler": nil
            }
        end
        return ret
    end

    def self.rearrange(dnb)
        ret = []
        bat = []
        all = []
        bow = []
        dnb.each do |list|
            p_id = list[0]
            if Player.find(p_id).skill == "bat"
                bat << list
            end
        end

        dnb.each do |list|
            p_id = list[0]
            if Player.find(p_id).skill == "all"
                all << list
            end
        end

        dnb.each do |list|
            p_id = list[0]
            if Player.find(p_id).skill == "bow"
                bow << list
            end
        end

        return bat + all + bow
    end

    def self.create_bowler_hash(list)
        flag = true
        i = 0
        bowling_hash = []
        total_overs = 0
        while flag and i<list.length
            if list[i]==[]
                flag = false
            else
                total_overs += 1
                bowling_hash.append({"over_no": list[i][0]})
            end
            i += 1
        end

        # iterate through bowlers
        over_count = 0
        while over_count<total_overs
            name = list[i].join(" ")
            runs_conceded = list[i+2][0]
            wickets = list[i+4][0]
            bowling_hash[over_count]["bowler"] = name.downcase
            bowling_hash[over_count]["runs"] = runs_conceded
            bowling_hash[over_count]["wickets"] = wickets
            i += 6
            over_count+=1
        end
        over_count = 0
        while over_count<total_overs
            if list[i].length == 1
                bowling_hash[over_count]["sequence"] = list[i][0].chars
            else
                bowling_hash[over_count]["sequence"] = list[i]
            end
            i += 1
            over_count += 1
        end
        return bowling_hash
    end

    def self.validate_temp_json
        file = File.read(MATCH_JSON_PATH)
        data = JSON.parse(file)
        inn1 = data["inn1"]
        status = Magic.validate_innings_json(inn1)
        unless status
            puts "Magic# Innings 1 ❌"
            return status
        end
        inn2 = data["inn2"]
        status = Magic.validate_innings_json(inn2)
        unless status
            puts "Magic# Innings 2 ❌"
            return status
        end
        return status

    end

    def self.validate_innings_json(inn)
        status = Magic.validate_batting_json(inn["batting"])
        return status unless status
        status = Magic.validate_bowling_json(inn["bowling"])
        return status
    end

    def self.validate_batting_json(batsmen)
        errors = []
        status = true
        if batsmen.length != 11
            errors << "batsmen length not 11, it is #{batsmen.length}"
        end
        batsmen.each do|batsman|
            if Util.get_pid(batsman["name"]).nil?
                errors << "batsman not found #{batsman["name"]}"
            end
            if batsman["fielder"] && Util.get_pid(batsman["fielder"]).nil?
                errors << "fielder not found #{batsman["fielder"]}"
            end
            if ['c','b','stumped','lbw',nil,'hit'].exclude? batsman["method"]
                errors << "out method not found #{batsman["name"]}, #{batsman["method"]}"
            end
            if batsman["method"] == "stumped"
                batsman["method"] == "st"
            end
        end
        if errors!=[]
            status = false
            print errors
        end
        return status
    end

    def self.validate_bowling_json(bowlers)
        errors = []
        status = true
        over_no = 1
        bowlers.each do |bowler|
            if bowler["over_no"].to_i!=over_no
                errors << "over_no not right #{bowler["over_no"]}"
            end
            if Util.get_pid(bowler["bowler"]).nil?
                errors << "bowler not found #{bowler["name"]}"
            end
            over_no += 1
        end
        if errors!=[]
            status = false
            print errors
        end
        return status
    end

    def self.validate_match_list(m_id, textfile)
        Magic.generate_temp_json(m_id, textfile)
        status = Magic.validate_temp_json
        if status == false
            puts "Magic# Match #{m_id} magic json is invalid ❌"
        else
            puts "Magic# Match #{m_id} magic json validated ✅"
        end
        return status
    end

    def self.get_spells_hash(list)
        list.reject!(&:empty?)
        spell_hash = []
        i = 0
        while i<list.length
            name = list[i].join(" ")
            overs = list[i+1][0].to_f
            runs = list[i+2][0].to_i
            wickets = list[i+3][0].to_i
            spell_hash << {
                "bowler": Util.get_pid(name.downcase),
                "overs": overs,
                "runs": runs,
                "wickets": wickets
            }
            i+=11
        end
        return spell_hash
    end

    def self.generate_temp_json(m_id, text_file)
        pdf_file_name = text_file
        list = Magic.read_file(pdf_file_name)

        temp_hash1 = Magic.get_team_score_index(list)

        start_index, end_index = Magic.get_batting_card_index(list)
        bat1 = list[start_index..end_index]
        bat1 = Magic.join_arrays2(bat1)
        bat_hash1 = Magic.create_batsmen_hash(bat1, temp_hash1[:team])
        start_index, end_index = Magic.get_spells_index(list)
        spell_hash1 = Magic.get_spells_hash(list[start_index..end_index])


        temp_hash1["batting"] = bat_hash1
        temp_hash1["spells"] = spell_hash1

        list = list[end_index..]
        start_index, end_index = Magic.get_bowling_card_index(list)
        bow1 = list[start_index..end_index]
        bow_hash1 = Magic.create_bowler_hash(bow1)
        temp_hash1["bowling"] = bow_hash1

        temp_hash2= Magic.get_team_score_index(list[end_index..])

        start_index, end_index = Magic.get_batting_card_index(list)
        bat2 = list[start_index..end_index]
        bat2 = Magic.join_arrays2(bat2)
        bat_hash2 = Magic.create_batsmen_hash(bat2,temp_hash2[:team])
        start_index, end_index = Magic.get_spells_index(list)
        spell_hash2 = Magic.get_spells_hash(list[start_index..end_index])
        temp_hash2["batting"] = bat_hash2
        temp_hash2["spells"] = spell_hash2

        list = list[end_index..]
        start_index, end_index = Magic.get_bowling_card_index(list)
        bow2 = list[start_index..end_index]
        bow_hash2 = Magic.create_bowler_hash(bow2)
        temp_hash2["bowling"] = bow_hash2



        match_hash = {"inn1": temp_hash1,
                    "inn2": temp_hash2}
        File.open(MATCH_JSON_PATH, 'w') do |file|
            file.write(JSON.pretty_generate(match_hash))
        end
    end
end

