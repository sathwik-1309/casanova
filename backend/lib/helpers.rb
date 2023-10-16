module Helper
    def self.construct_bat_stats_hash(scores)
        hash = {}
        scores.each do |score|
            hash[score.player_id] = Helper.set_bat_stats_hash_configs(score.player_id, score.squad_id) unless hash[score.player_id]
            hash[score.player_id] = Helper.update_bat_stats_hash(hash[score.player_id], score)
        end
        return Helper.update_bat_stats_hash2(hash)
    end

    def self.update_bat_stats_hash(hash, score)
        hash["runs"] += score.runs
        hash["balls"] += score.balls
        hash["innings"] += 1
        hash["dots"] += score.dots
        hash["fours"] += score.c4
        hash["sixes"] += score.c6
        hash["fifties"] += 1 if score.runs >= 50
        hash["thirties"] += 1 if score.runs >= 30
        hash["hundreds"] += 1 if score.runs >= 100
        hash["dismissed"] += 1 if score.not_out == false
        if hash["best_runs"] < score.runs or (hash["best_runs"] == score.runs and hash["best_balls"] > score.balls)
            hash["best_runs"] = score.runs
            hash["best_runs_with_notout"] = score.get_runs_with_notout
            hash["best_balls"] = score.balls
            hash["best_id"] = score.id
        end
        return hash
    end

    def self.set_bat_stats_hash_configs(p_id, squad_id)
        hash = {}
        hash["p_id"] = p_id
        hash["runs"] = 0
        hash["balls"] = 0
        hash["innings"] = 0
        hash["dots"] = 0
        hash["fours"] = 0
        hash["sixes"] = 0
        hash["fifties"] = 0
        hash["thirties"] = 0
        hash["hundreds"] = 0
        hash["dismissed"] = 0
        hash["best_runs"] = 0
        hash["best_balls"] = 0
        hash["squad_id"] = squad_id
        return hash
    end

    def self.update_bat_stats_hash2(hash)
        return_array = []
        hash.each do|p_id, stats|
            temp = stats
            if stats["balls"]>0
                temp["sr"] = ((stats["runs"].to_f*100)/stats["balls"].to_f).round(2)
                if stats["dismissed"] > 0
                    temp["avg"] = (stats["runs"].to_f/stats["dismissed"].to_f).round(2)
                else
                    temp["avg"] = nil
                end
                temp["dot_p"] = ((stats["dots"].to_f*100)/stats["balls"].to_f).round(2)
                temp["boundary_p"] = (((stats["fours"]+stats["sixes"]).to_f*100)/stats["balls"].to_f).round(2)
            else
                temp["avg"] = 0
                temp["sr"] = 0
                temp["dot_p"] = 0
                temp["boundary_p"] = 0
            end

            return_array << temp
        end
        return return_array
    end

    def self.format_individual_stats(hash, total, info, t_id)
        list = []
        count = 0
        hash.each do|player|
            count += 1
            temp = {}
            temp["name"] = Util.case(Player.find(player["p_id"]).fullname, t_id.to_i)
            temp["data1"] = player[total]
            temp["data2"] = Helper.construct_lci_info(info, player[info])
            temp["p_id"] = player["p_id"]
            squad = Squad.find(player["squad_id"])
            temp["teamname"] = "#{Util.get_flag(squad.team_id)} #{squad.abbrevation.upcase}"
            temp["color"] = Util.get_team_color(t_id, squad.abbrevation)
            temp["pos"] = count
            list << temp
        end
        return list
    end

    def self.construct_lci_info(attribute, value)
        case attribute
        when "innings"
            return "Matches : #{value}"
        when "runs"
            return "Runs : #{value}"
        when "wickets"
            return "Wickets : #{value}"
        when "eco"
            return "Economy : #{value}"
        end
        return "not known: #{attribute}"

    end

    def self.construct_ball_stats_hash(spells)
        hash = {}
        spells.each do |spell|
            hash[spell.player_id] = Helper.set_ball_stats_hash_configs(spell.player_id, spell.squad_id) unless hash[spell.player_id]
            hash[spell.player_id] = Helper.update_ball_stats_hash(hash[spell.player_id], spell)
        end
        return Helper.update_ball_stats_hash2(hash)
    end

    def self.set_ball_stats_hash_configs(p_id, squad_id)
        hash = {}
        hash["p_id"] = p_id
        hash["innings"] = 0
        hash["balls"] = 0
        hash["wickets"] = 0
        hash["runs"] = 0
        hash["dots"] = 0
        hash["fours"] = 0
        hash["sixes"] = 0
        hash["_3w"] = 0
        hash["maidens"] = 0
        hash["best_wickets"] = 0
        hash["best_runs"] = 0
        hash["_5w"] = 0
        hash["squad_id"] = squad_id
        return hash
    end

    def self.update_ball_stats_hash(hash, spell)
        hash["runs"] += spell.runs
        hash["balls"] += Util.overs_to_balls(spell.overs)
        hash["innings"] += 1
        hash["wickets"] += spell.wickets
        hash["dots"] += spell.dots
        hash["fours"] += spell.c4
        hash["sixes"] += spell.c6
        hash["_3w"] += 1 if spell.wickets >= 3
        hash["_5w"] += 1 if spell.wickets >= 5
        hash["maidens"] += spell.maidens
        if hash["best_wickets"] < spell.wickets or (hash["best_wickets"] == spell.wickets and hash["best_runs"] > spell.runs)
            hash["best_fig"] = spell.get_fig
            hash["best_overs"] = spell.overs
            hash["best_wickets"] = spell.wickets
            hash["best_runs"] = spell.runs
            hash["best_id"] = spell.id
        end
        return hash
    end

    def self.update_ball_stats_hash2(hash)
        return_array = []
        hash.each do|p_id, stats|
            temp = stats
            temp["eco"] =  ((stats["runs"].to_f*6)/stats["balls"].to_f).round(2)
            if stats["wickets"] > 0
                temp["avg"] = (stats["runs"].to_f/stats["wickets"].to_f).round(2)
                temp["sr"] = ((stats["balls"].to_f)/stats["wickets"].to_f).round(2)
            else
                temp["avg"] = nil
                temp["sr"] = nil
            end
            temp["dot_p"] = ((stats["dots"].to_f*100)/stats["balls"].to_f).round(2)
            temp["boundary_p"] = (((stats["fours"]+stats["sixes"]).to_f*100)/stats["balls"].to_f).round(2)
            return_array << temp
        end
        return return_array
    end

    def self.get_player_batstats(scores, p_id)
        hash = {}
        hash["matches"] = scores.length
        scores = scores.where(batted: true)
        hash["innings"] = scores.length
        hash["runs"] = 0
        hash["fours"] = 0
        hash["sixes"] = 0
        hash["thirties"] = 0
        hash["fifties"] = 0
        hash["hundreds"] = 0
        hash["not_outs"] = 0
        balls = 0
        dots = 0

        scores.each do|score|
            hash["runs"] += score.runs
            hash["fours"] += score.c4
            hash["sixes"] += score.c6
            balls += score.balls
            dots += score.dots

            hash["thirties"] += 1 if score.runs >= 30
            hash["fifties"] += 1 if score.runs >= 50
            hash["hundreds"] += 1 if score.runs >= 100
            hash["not_outs"] += 1 if score.not_out
        end

        if hash["runs"] > 0
            if hash["innings"] - hash["not_outs"] > 0
                dismissed = hash["innings"] - hash["not_outs"]
                hash["average"] = (hash["runs"].to_f/dismissed.to_f).round(2)
            else
                hash["average"] = "-"
            end
            hash["sr"] = ((hash["runs"].to_f*100)/balls.to_f).round(2)
            hash["boundary_p"] = "#{(((hash["fours"]+hash["sixes"]).to_f*100)/balls.to_f).round(2)} %"
            hash["dot_p"] = "#{((dots.to_f*100)/balls.to_f).round(2)} %"
        else
            hash["average"] = "-"
            hash["sr"] = "-"
            hash["dot_p"] = "-"
            hash["boundary_p"] = "-"
        end
        return hash
    end

    def self.get_player_ballstats(spells, p_id, matches)
        hash = {}
        hash["matches"] = matches
        hash["innings"] = spells.length
        hash["wickets"] = 0
        hash["fours"] = 0
        hash["sixes"] = 0
        hash["_3w"] = 0
        hash["_5w"] = 0
        hash["maidens"] = 0
        dots = 0
        balls = 0
        runs = 0
        spells.each do|spell|
            hash["wickets"] += spell.wickets
            hash["fours"] += spell.c4
            hash["sixes"] += spell.c6
            hash["maidens"] += spell.maidens
            balls += Util.overs_to_balls(spell.overs)
            dots += spell.dots
            runs += spell.runs
            hash["_3w"] += 1 if spell.wickets >= 3
            hash["_5w"] += 1 if spell.wickets >= 5
        end
        hash["overs"] = Util.balls_to_overs(balls)
        hash["economy"] = ((runs.to_f*6)/balls.to_f).round(2)
        hash["boundary_p"] = "#{(((hash["fours"]+hash["sixes"]).to_f*100)/balls.to_f).round(2)} %"
        hash["dot_p"] = "#{((dots.to_f*100)/balls.to_f).round(2)} %"
        if hash["wickets"] > 0
            hash["sr"] = (balls.to_f/hash["wickets"].to_f).round(2)
            hash["average"] = (runs.to_f/hash["wickets"].to_f).round(2)
        else
            hash["sr"] = '-'
            hash["average"] = '-'
        end
        return hash
    end

    # player#ball_stats
    def self.repeat1(spells, p_id, t_id, player, team, tour, matches)
        hash = {}
        hash = Helper.get_player_ballstats(spells, p_id.to_i, matches)
        hash["playername"] = Util.case(player.fullname, t_id)
        hash["tour"] = tour
        hash["teamname"] = team.get_teamname
        hash["color"] = team.abbrevation
        return hash
    end

    #player#bat_stats
    def self.repeat2(scores, p_id, t_id, player, team, tour)
        hash = {}
        hash = Helper.get_player_batstats(scores, p_id.to_i)
        hash["playername"] = Util.case(player.fullname, t_id)
        hash["tour"] = tour
        hash["teamname"] = team.get_teamname
        hash["color"] = team.abbrevation
        return hash
    end

    def self.tournament_class_box(tour_type)
        hash = {}
        tours = Tournament.where(name: tour_type).where(ongoing: false)
        total_tours = Tournament.where(name: tour_type)
        latest_winner = tours.last.winners
        hash["tour_name"] = tour_type.upcase
        hash["w_teamname"] = latest_winner.get_teamname
        hash["w_color"] = latest_winner.abbrevation
        hash["tournaments"] = total_tours.length
        hash["matches"] = Match.where(tournament_id: total_tours.pluck(:id)).count
        return hash
    end

    def self.group_by_team(hashes, key)
        grouped_hash = {}

        hashes.each do |hash|
            color = hash[key]
            if grouped_hash[color]
                grouped_hash[color][hash["skill"].downcase] << hash
                # grouped_hash[color] << hash
            else
                grouped_hash[color] = {}
                grouped_hash[color]['bat'] = []
                grouped_hash[color]['wk'] = []
                grouped_hash[color]['all'] = []
                grouped_hash[color]['bow'] = []
                grouped_hash[color][hash["skill"].downcase] = [hash]
                # grouped_hash[color] = [hash]
            end
        end
        grouped_hash
    end

    def self.construct_player_details(player)
        hash = {}
        hash["name"] = player.fullname.length > 13 ? player.name.titleize : player.fullname.titleize
        hash["p_id"] = player.id
        if player.keeper
            hash["skill"] = "WK"
        else
            hash["skill"] = player.skill.upcase
        end
        hash["batting_hand"] = player.batting_hand
        hash["bowling_hand"] = player.bowling_hand
        hash["bowling_style"] = player.bowling_style
        return hash
    end

    def self.construct_players_hash_for_tour(tour_ids, players)
        array = []
        temp = Score.where(tournament_id: tour_ids).pluck(:player_id, :squad_id).uniq
        squads = Squad.all
        teams = Team.all
        temp2 = temp.map { |array| [array[0], squads.find(array[1]).team_id] }
        temp2 = temp2.uniq
        temp2.each do |a|
            player = players.find(a[0])
            team_id = a[1]
            hash = Helper.construct_player_details(player)
            team = teams.find(team_id)
            hash["color"] = team.abbrevation
            hash["teamname"] = team.get_teamname
            array << hash
        end
        return array
    end

    def self.bat_stats_to_hash(selected, sort_key, t_id)
        arr = []
        players = Player.where(id: selected.pluck(:player_id))
        count = 0
        selected.each do|stats|
            count += 1
            hash = {}
            player = players.find { |obj| obj.id == stats.player_id }
            hash['name'] = Util.case(player.fullname, t_id.to_i)
            hash['p_id'] = player.id
            squad = Squad.find(Score.find_by(tournament_id: t_id, player_id: player.id).squad_id)
            hash['teamname'] = squad.get_abb
            hash['color'] = Util.get_team_color(t_id, squad.abbrevation)
            hash['pos'] = count
            hash['data1'] = stats.send(sort_key.to_sym)
            hash['data2'] = "Innings: #{stats.innings}"
            arr << hash
        end
        return arr
    end

    def self.upcoming_match_team_to_hash(squad)
        hash = {}
        hash['teamname'] = squad.get_abb
        hash['color'] = Util.get_team_color(squad.tournament_id, squad.abbrevation)
        hash['captain_id'] = squad.captain_id
        hash
    end

    def self.get_tour_class_ids(t_id)
        if Tournament.wt20_ids.include? t_id
            return Tournament.wt20_ids
        elsif Tournament.ipl_ids.include? t_id
            return Tournament.ipl_ids
        elsif Tournament.csl_ids.include? t_id
            return Tournament.csl_ids
        else
            raise StandardError.new("Helpers#get_tour_class_ids: no tour_class for t_id #{t_id}")
        end
    end

    def self.get_tour_class_ids2(type)
        case type
        when 'wt20'
            return Tournament.wt20_ids
        when 'ipl'
            return Tournament.ipl_ids
        when 'csl'
            return Tournament.csl_ids
        end
    end

    def self.construct_tour_class_bat_stats(stats, field, header, tour_class, field2='innings')
        box = {}
        box['header'] = header
        box['data'] = []
        temp_stats = stats
        pos = 0
        temp_stats.each do|stat|
            pos += 1
            temp = {}
            player = stat.player
            temp['p_id'] = stat.player_id
            temp['name'] = player.fullname.titleize
            team = player.get_tour_class_team(tour_class)
            temp['color'] = team.abbrevation
            temp['pos'] = pos
            temp['teamname'] = team.get_abb
            temp['data1'] = stat.send(field.to_sym)
            temp['data2'] = "#{field2.titleize}: #{stat.send(field2.to_sym)}"
            box['data'] << temp
        end
        box
    end

    def self.construct_ball_stats_hash2(spells)
        balls = 0
        runs = 0
        dots = 0
        boundaries = 0
        best_spell = nil
        h = {
          'innings' => 0,
          'wickets' => 0,
          'maidens' => 0,
          'three_wickets' => 0,
          'five_wickets' => 0,
        }
        spells.each do |spell|
            h['innings'] += 1
            balls += Util.overs_to_balls(spell.overs)
            h['wickets'] += spell.wickets
            runs += spell.runs
            h['maidens'] += spell.maidens
            h['three_wickets'] += 1 if spell.wickets >= 3
            h['five_wickets'] += 1 if spell.wickets >= 5
            dots += spell.dots
            boundaries += (spell.c4 + spell.c6)
            best_spell = Spell.get_better_spell(best_spell, spell) if spell.wickets >= 1
        end
        h['overs'] = Util.balls_to_overs(balls)
        h['economy'] = Util.get_rr(runs, balls)
        h['avg'] = (runs.to_f/h['wickets']).round(2)
        h['sr'] = (runs.to_f/balls).round(2)
        h['dot_p'] = (dots.to_f/balls).round(2)
        h['boundary_p'] = (boundaries.to_f/balls).round(2)
        h['best_spell'] = nil
        unless best_spell.nil?
            h['best_spell'] = best_spell.spell_box
        end
        return h
    end

    def self.construct_bat_stats_hash2(scores)
        balls = 0
        not_outs = 0
        dots = 0
        boundaries = 0
        best_score = nil
        h = {
          'innings' => 0,
          'runs' => 0,
          'fours' => 0,
          'sixes' => 0,
          'thirties' => 0,
          'fifties' => 0,
          'hundreds' => 0,
        }
        scores.each do |score|
            h['innings'] += 1
            balls += score.balls
            h['runs'] += score.runs
            not_outs += 1 if score.not_out
            h['fours'] += score.c4
            h['sixes'] += score.c6
            h['thirties'] += 1 if score.runs >= 30
            h['fifties'] += 1 if score.runs >= 50
            h['hundreds'] += 1 if score.runs >= 100
            dots += score.dots
            boundaries += (score.c4 + score.c6)
            best_score = Score.get_better_score(best_score, score) if score.runs > 0
        end
        h['sr'] = Util.get_sr(h['runs'], balls)
        outs = h['innings']-not_outs
        if outs > 0
            h['avg'] = (h['runs'].to_f/outs).round(2)
        else
            h['avg'] = '-'
        end
        h['dot_p'] = (dots.to_f/balls).round(2)
        h['boundary_p'] = (boundaries.to_f/balls).round(2)
        h['best_score'] = nil
        unless best_score.nil?
            h['best_score'] = best_score.score_box
        end
        return h
    end

end

