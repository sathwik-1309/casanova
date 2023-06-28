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
            temp["color"] = squad.abbrevation
            temp["pos"] = count
            list << temp
        end
        return list
    end

    def self.construct_lci_info(attribute, value)
        case attribute
        when "innings"
            return "M : #{value}"
        when "runs"
            return "R : #{value}"
        when "wickets"
            return "W : #{value}"
        when "eco"
            return "E : #{value}"
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
        tours = Tournament.where(name: tour_type).where('winners_id != 0')
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

end

