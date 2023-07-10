module Util
    def self.overs_to_balls(overs)
        o = overs.to_s.split(".")
        balls = (o[0].to_i * 6)+ o[1].to_i
        return balls
    end

    def self.balls_to_overs(balls)
        o = balls/6
        b = balls%6
        overs = "#{o}.#{b}".to_f
        return overs
    end

    def self.get_pid(name)
        file = File.read(PLAYERS_JSON_PATH)
        data = JSON.parse(file)
        data.each do|player|
            if player["names"].include? name
                return player["id"]
            end
        end
        return nil if name == nil
        if name == ""
            raise "get_pid# name is nil"
        end
        raise "Player not found #{name}"

    end

    def self.get_pid_team(name, team_id)
        file = File.read(PLAYERS_JSON_PATH)
        data = JSON.parse(file)
        data.each do|player|
            if [player["country"],player["ipl"],player["csl"]].include? team_id
                if player["names"].include? name
                    return player["id"]
                end
            end
        end
        return nil if name == nil
        raise "Player not found #{name} for #{team_id}"
    end

    def self.add_batsman_runs(sr, b1, b2, runs)
        if runs == 0
            cat = "dots"
        elsif runs == 1
            cat = "c1"
        elsif runs == 2
            cat = "c2"
        elsif runs == 3
            cat = "c3"
        elsif runs == 4
            cat = "c4"
        elsif runs == 6
            cat = "c6"
        else
            puts "add_batsman_runs# runs not found #{runs}"
        end
        if b1["id"]==sr
            b1["runs"] += runs
            b1["balls"] += 1
            b1[cat] += 1
        else
            b2["runs"] += runs
            b2["balls"] += 1
            b2[cat] += 1
        end
        if (runs.to_i)%2==1
            sr = Util.change_strike(sr, b1, b2)
        end
        return sr, b1, b2
    end

    def self.change_strike(sr, b1, b2)
        if sr == b1["id"]
            return b2["id"]
        else
            return b1["id"]
        end
    end

    def self.get_sr(runs, balls)
        return ((runs.to_f*100)/balls.to_f).round(2)
    end

    def self.get_avg(runs, outs)
        if outs == 0
            return nil
        end
        return (runs.to_f/outs.to_f).round(2)
    end

    def self.get_economy(runs, overs)
        return ((runs.to_f*6)/(Util.overs_to_balls(overs)).to_f).round(2)
    end

    def self.get_bow_sr(overs, wickets)
        # return nil if wickets == 0
        return (((Util.overs_to_balls(overs)).to_f)/(wickets.to_f)).round(2)
    end

    def self.get_bow_avg(runs, wickets)
        # return nil if wickets == 0
        return ((runs.to_f)/(wickets.to_f)).round(2)
    end

    def self.get_boundary_p(c4, c6, balls)
        return ((c4+c6).to_f*100/balls.to_f).round(2)
    end

    def self.get_dot_p(c0, balls)
        return (c0.to_f*100/balls.to_f).round(2)
    end

    def self.format_overs(num)
        if num.floor == num
            num = num.floor
        end
        return num
    end

    def self.get_flag(id)
        flags = {1 => "🇮🇳",2 => "🇵🇰",3 => "🇳🇿",4 => "🇦🇺",5 => "🇦🇱",6 => "🇿🇦",7 => "🇬🇧",8 => "🇧🇩",9 => "🇦🇫",10 => "🇱🇰",11 => "🇳🇵",12 => "🇿🇼",
                    31 => "🐲",32 => "🦌",33 => "🦅",34 => "🧿",35 => "💀",36 => "🕊",37 => "🦂",38 => "🪄",39 => "🐬",40 => "💫",41 => "🍁",42 => "🦊"}
        if flags.keys().include? id
            return flags[id]
        else
            return ''
        end
    end

    def self.get_runs_with_notout(score)
        if score.not_out
            return "#{score.runs}*"
        else
            return "#{score.runs}"
        end
    end

    def self.case(name, t_id)
        if [1,4,5].include? t_id
            return name.titleize
        elsif [3,6].include? t_id
            return  name.titleize
        elsif [2].include? t_id
            return  name.upcase
        end
    end

    def self.get_tournament_json(t_id)
        file = File.read(TOURNAMENT_JSON_PATH)
        data = JSON.parse(file)
        data.each do |tour|
            if tour["id"] == t_id
                return tour
            end
        end
    end

    def self.format_nrr(float_value)
        sign = float_value >= 0 ? '+' : '-'
        formatted_float = sprintf('%.2f', float_value.abs)
        "#{sign} #{formatted_float}"
    end

    def self.get_score(score, wickets)
        if wickets == 10
            return "#{score}"
        else
            return "#{score} - #{wickets}"
        end
    end

    def self.get_sr(runs, balls)
        return ((runs.to_f*100)/balls.to_f).round(2)
    end

    def self.get_rr(runs, balls)
        rr = ((runs*6).to_f/balls)
        rr = sprintf('%.2f', rr.abs)
        return rr
    end

    def self.ordinal_suffix(number)
        return number.to_s + "th" if (11..13).include?(number % 100)

        case number % 10
        when 1 then number.to_s + "st"
        when 2 then number.to_s + "nd"
        when 3 then number.to_s + "rd"
        else number.to_s + "th"
        end
    end


end

