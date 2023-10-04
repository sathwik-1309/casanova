module Validator
    def self.validate_match
        file = File.read(MATCH_JSON_PATH)
        magic_json = JSON.parse(file)

        file = File.read(MATCH_INGEST_JSON_PATH)
        ingest_json = JSON.parse(file)

        status = Validator.innings_json(magic_json["inn1"],ingest_json["inn1"] )
        if status
            puts "Validator# Validated inn1 ✅"
        else
            puts "Validator# Validation failed ❌"
        end
        return status unless status
        status = Validator.innings_json(magic_json["inn2"],ingest_json["inn2"] )
        if status
            puts "Validator# Validated inn2 ✅"
        else
            puts "Validator# Validation failed ❌"
        end
        return status
    end

    def self.innings_json(magic_json, ingest_json)
        status = Validator.score(magic_json, ingest_json)
        return status unless status
        status = Validator.batsmen_scores(magic_json["batting"], ingest_json["batting"])
        return status unless status
        status = Validator.spells(magic_json["spells"], ingest_json["spells"])
        return status
    end

    def self.spells(magic_json, ingest_json)
        status = true
        errors = []
        index = 0
        while index < ingest_json.length
            ingest_bow = ingest_json[index]
            magic_bow = magic_json[index]
            if magic_bow["bowler"] != ingest_bow["bowler"]
                errors << "Spell Bowler not same. #{magic_bow["bowler"]} , #{ingest_bow["bowler"]}"
            end
            if magic_bow["overs"] != ingest_bow["overs"]
                errors << "Spell overs not same for #{magic_bow["bowler"]}. #{magic_bow["overs"]} , #{ingest_bow["overs"]}"
            end
            if magic_bow["runs"] != ingest_bow["runs"]
                errors << "Spell runs not same for #{magic_bow["bowler"]}. #{magic_bow["runs"]} , #{ingest_bow["runs"]}"
            end
            if magic_bow["wickets"] != ingest_bow["wickets"]
                errors << "Spell wickets not same for #{magic_bow["bowler"]}. #{magic_bow["wickets"]} , #{ingest_bow["wickets"]}"
            end
            index += 1
        end
        if errors!=[]
            status = false
            puts errors
        end
        return status
    end

    def self.score(magic_json, ingest_json)
        status = true
        errors = []
        # validate inn1 scores
        if magic_json["score"].to_i != ingest_json["score"]
            errors << "Inn scores not matching. #{magic_json["score"].to_i} , #{ingest_json["score"]}"
        end
        if magic_json["for"].to_i != ingest_json["for"]
            errors << "Inn wickets not matching. #{magic_json["for"].to_i} , #{ingest_json["for"]}"
        end
        if magic_json["overs"].to_f != ingest_json["overs"]
            errors << "Inn overs not matching. #{magic_json["overs"].to_i} , #{ingest_json["overs"]}"
        end

        if errors!=[]
            status = false
            puts errors
        end
        return status
    end

    def self.batsmen_scores(magic_json, ingest_json)
        status = true
        errors = []
        index = 0
        while index < ingest_json.length
            ingest_bat = ingest_json[index]
            magic_bat = magic_json[index]
            if Util.get_pid(magic_bat["name"])!= ingest_bat["id"]
                errors << "Batsman id not matching. #{Util.get_pid(magic_bat["name"])}, #{ingest_bat["id"]}"
            end
            if magic_bat["batted"] != ingest_bat["batted"]
                errors << "Batted not same for #{magic_bat["name"]}. #{magic_bat["batted"]} , #{ingest_bat["batted"]}"
            end

            if ingest_bat["batted"] == true
                if magic_bat["method"] != ingest_bat["method"]
                    errors << "Batted not same for #{magic_bat["name"]}. #{magic_bat["method"]} , #{ingest_bat["method"]}"
                end
                if Util.get_pid(magic_bat["bowler"]) != ingest_bat["bowler"]
                    errors << "bowler not same for #{magic_bat["name"]}. #{Util.get_pid(magic_bat["bowler"])} , #{ingest_bat["bowler"]}"
                end
                if magic_bat["fielder"] != ingest_bat["fielder"]
                    errors << "fielder not same for #{magic_bat["name"]}. #{magic_bat["fielder"]} , #{ingest_bat["fielder"]}"
                end
                if magic_bat["runs"] != ingest_bat["runs"]
                    errors << "runs not same for #{magic_bat["name"]}. #{magic_bat["runs"]} , #{ingest_bat["runs"]}"
                end
                if magic_bat["balls"] != ingest_bat["balls"]
                    errors << "runs not same for #{magic_bat["name"]}. #{magic_bat["balls"]} , #{ingest_bat["balls"]}"
                end
                if magic_bat["not_out"] != ingest_bat["not_out"]
                    errors << "not_out not same for #{magic_bat["name"]}. #{magic_bat["not_out"]} , #{ingest_bat["not_out"]}"
                end
            end
            index += 1
        end
        if errors!=[]
            status = false
            puts errors
        end
        return status
    end

    def self.check_schedule_entry(args)
        t_id = args['t_id']
        team1 = Squad.find_by(team_id: Team.find_by(abbrevation: args['batted_first']).id, tournament_id: t_id)
        team2 = Squad.find_by(team_id: Team.find_by(abbrevation: args['batted_second']).id, tournament_id: t_id)
        # base_query = Schedule.where(tournament_id: t_id, completed: false, venue: args['venue'], stage: args['stage'])
        # query1 = base_query.where(squad1_id: team1.id, squad2_id: team2.id)
        # query2 = base_query.where(squad1_id: team2.id, squad2_id: team1.id)
        schedule = Schedule.find(args['m_id'])
        status = Validator.verify_next_schedule(schedule, args, team1, team2)
        return false unless status
        status = Validator.update_schedule(schedule, args)
        return false unless status
        return true
    end

    def self.update_schedule(schedule, args)
        schedule.completed = true
        unless schedule.save
            puts "❌Validator#update_schedule: Schedule could not be updated for match #{args['m_id']}"
            return false
        end
        return true
    end

    def self.verify_next_schedule(schedule, args, team1, team2)
        status = true
        if schedule.id != args['m_id']
            status = false
        end
        if schedule.tournament_id != args['t_id']
            status = false
        end
        if schedule.venue != args['venue']
            status = false
        end
        if schedule.stage != args['stage']
            status = false
        end
        # if schedule.completed != false
        #     status = false
        # end
        if [team1.id, team2.id].exclude? schedule.squad1_id
            status = false
        end
        if [team1.id, team2.id].exclude? schedule.squad2_id
            status = false
        end
        unless status
            puts "❌Validator#verify_next_schedule: Schedule not same as match #{args['m_id']}"
        end
        return status
    end

end
