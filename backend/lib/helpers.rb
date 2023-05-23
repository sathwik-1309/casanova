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
        hash["dismissed"] += 1 if score.not_out == false
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
        hash["dismissed"] = 0
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
        hash["3w"] = 0
        hash["maidens"] = 0
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
        hash["3w"] += 1 if spell.wickets >= 3
        hash["maidens"] += spell.maidens
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

end

