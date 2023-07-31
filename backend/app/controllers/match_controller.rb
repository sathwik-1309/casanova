
class MatchController < ApplicationController
    def summary
        m_id = params[:m_id]

        match = Match.find(m_id)
        hash = {}
        toss = match.toss_id
        hash["inn1"] = get_innings_summary(match.inn1, toss)
        hash["inn2"] = get_innings_summary(match.inn2, toss)
        hash["tour"] = match.get_tour_font
        hash["venue"] = match.venue
        hash["stage"] = match.stage
        hash["header"] = {
            "tour" => "#{Tournament.find(match.tournament_id).name}",
            "title1" => "#{Tournament.find(match.tournament_id).name.upcase} (#{match.id})",
            "title2" => "#{match.venue.titleize} (#{match.stage.titleize})",
            "title3" => "#{match.inn1.bat_team.get_teamname}  vs  #{match.inn2.bat_team.get_teamname}"
        }
        footer = {}
        footer["tour"] = "#{Tournament.find(match.tournament_id).name}"
        if match.win_by_runs==nil and match.win_by_wickets==nil
            result = "won by super over"
        elsif match.win_by_wickets==nil
            result = "won by #{match.win_by_runs} runs"
        else
            result = "won by #{match.win_by_wickets} wickets"
        end
        result = "#{Util.get_flag(Squad.find(match.winner_id).team_id)} #{Squad.find(match.winner_id).abbrevation.upcase} #{result}"
        footer["result"] = result
        footer["result_color"] = Util.get_team_color(match.tournament_id, Squad.find(match.winner_id).abbrevation)

        motm = {}
        motm["name"] = Util.case(match.motm.fullname, match.tournament_id)
        motm["pid"] = match.motm_id
        motm["color"] = Squad.find(Performance.find_by(player: match.motm_id, match_id: m_id).squad_id).abbrevation
        score = Score.where(match_id: m_id, player_id: match.motm_id).first
        if score.batted and score.runs > 0
            runs = Util.get_runs_with_notout(score)
            motm["bat"] = {
                "runs" => runs,
                "balls" => score.balls
            }
        end
        spell = Spell.where(match_id: m_id, player_id: match.motm_id).first
        if spell
            motm["ball"] = {
                "fig" => "#{spell.wickets} - #{spell.runs}",
                "overs" => Util.format_overs(spell.overs)
            }
        end
        footer["motm"] = motm
        hash["footer"] = footer
        milestones = Milestone.where(match_id: m_id).order(sub_type: :desc)
        ml_messages = []
        milestones.each do|ml|
            ml_messages << ml.get_message_hash
        end
        ml_messages = ml_messages.group_by {|ml_hash| ml_hash['color'] }
        arr1 = ml_messages[Util.get_team_color(match.tournament_id, match.inn1.bat_team.abbrevation)] || []
        arr2 = ml_messages[Util.get_team_color(match.tournament_id, match.inn1.bow_team.abbrevation)] || []
        hash["milestones"] =  arr1 + arr2
        hash['highlights'] = match.get_highlights_hash
        render(:json => Oj.dump(hash))
    end

    def get_innings_summary(inn, toss)
        hash = {}
        m_id = inn.match_id
        hash["teamname"] = inn.bat_team_id == toss ? "#{inn.bat_team.get_teamname} 🪙" : inn.bat_team.get_teamname
        hash["bat_team"] = Util.get_team_color(inn.tournament_id, Squad.find(inn.bat_team_id).abbrevation)
        hash["bow_team"] = Util.get_team_color(inn.tournament_id, Squad.find(inn.bow_team_id).abbrevation)
        hash["score"] = Util.get_score(inn.score, inn.for)
        hash["overs"] = Util.format_overs(inn.overs)
        hash["bat"] = []
        scores = Score.where(inning_id: inn.id, batted: true).where("runs > 0").order(runs: :desc, balls: :asc).limit(4)
        scores.each do|score|
            temp = []
            temp << Util.case(Player.find(score.player_id).name, inn.tournament_id)
            temp << score.runs
            temp << score.balls
            if score.not_out
                temp << "*"
            else
                temp << ""
            end
            temp << score.score_box
            hash["bat"] << temp
        end
        hash["ball"] = []
        spells = Spell.where(inning_id: inn.id).where('wickets > ?', 0).order(wickets: :desc, runs: :asc).limit(4)
        spells.each do |spell|
            temp = []
            temp << Util.case(Player.find(spell.player_id).name, inn.tournament_id)
            temp << "#{spell.wickets} - #{spell.runs}"
            temp << Util.format_overs(spell.overs)
            temp << spell.spell_box
            hash["ball"] << temp
        end
        return hash
    end

    def scorecard
        m_id = params[:m_id]
        inn_no = params[:inn_no]

        hash = {}
        header = {}
        inn = Inning.find_by(match_id: m_id, inn_no: inn_no)
        t_id = inn.tournament_id
        team = inn.bat_team

        header["teamname"] = team.get_teamname
        header["color"] = Util.get_team_color(t_id, team.abbrevation)
        header["score"] = Util.get_score(inn.score, inn.for)
        header["overs"] = Util.format_overs(inn.overs)
        header["fours"] = inn.c4
        header["sixes"] = inn.c6
        header["dots"] = inn.dots

        body = []
        scores = inn.scores
        scores.each do |score|
            temp = {}
            temp["name"] = Util.case(Player.find(score.player_id).name, t_id)
            temp["p_id"] = score.player_id
            temp["batted"] = score.batted
            if score.batted
                temp["runs"] = Util.get_runs_with_notout(score)
                temp["balls"] = score.balls
                temp["not_out"] = score.not_out
                if score.not_out
                    temp["data1"] = "not out"
                else
                    temp["data1"] = score.wicket.get_data1
                    temp["data2"] = score.wicket.get_data2
                end
            else
                temp["runs"] = ""
                temp["balls"] = ""
                temp["data1"] = ""
                temp["data2"] = "did not bat"
            end
            temp["scorebox"] = score.score_box
            body << temp
        end

        hash["header"] = header
        hash["body"] = body
        hash["tour"] = Match.find(m_id).get_tour_font
        render(:json => Oj.dump(hash))
    end

    def fow
        m_id = params[:m_id]
        inn_no = params[:inn_no]

        inn = Inning.find_by(match_id: m_id, inn_no: inn_no)
        t_id = inn.tournament_id
        team = inn.bat_team

        hash = {}
        fow = []
        wickets = inn.wickets
        wickets.each do |wicket|
            temp = {}
            temp["score"] = "#{wicket.ball.score} - #{wicket.ball.for}"
            temp["delivery"] = wicket.delivery
            temp["batsman"] = Util.case(wicket.batsman.name, t_id)
            temp["bowler"] = Util.case(wicket.bowler.name, t_id)
            temp["ball_color"] = wicket.ball.ball_color
            fow << temp
        end

        hash["fow"] = fow
        hash["tour"] = Match.find(m_id).get_tour_font
        hash["color"] = Util.get_team_color(t_id, team.abbrevation)
        hash["teamname"] = team.get_teamname
        render(:json => Oj.dump(hash))
    end

    def bowling_card
        m_id = params[:m_id]
        inn_no = params[:inn_no]

        inn = Inning.find_by(match_id: m_id, inn_no: inn_no)
        t_id = inn.tournament_id
        team = inn.bow_team

        hash = {}
        bowlers = []
        spells = inn.spells
        spells.each do |spell|
            temp = {}
            temp["name"] = Util.case(spell.player.name, t_id)
            temp["runs"] = spell.runs
            temp["overs"] = Util.format_overs(spell.overs)
            temp["wickets"] = spell.wickets
            temp["maidens"] = spell.maidens
            temp["er"] = spell.economy
            temp["dots"] = spell.dots
            temp["spellbox"] = spell.spell_box
            bowlers << temp
        end

        hash["tour"] = Match.find(m_id).get_tour_font
        hash["color"] = Util.get_team_color(t_id, team.abbrevation)
        hash["teamname"] = team.get_teamname
        hash["bowlers"] = bowlers
        render(:json => Oj.dump(hash))
    end

    def manhatten
        m_id = params[:m_id]
        inn_no = params[:inn_no]

        inn = Inning.find_by(match_id: m_id, inn_no: inn_no)
        t_id = inn.tournament_id
        team = inn.bow_team

        hash = {}
        overs_list = []
        overs = inn.get_overs
        overs.each do |over|
            temp = {}
            temp["over_no"] = over.over_no
            temp["runs"] = over.runs
            temp["bowler"] = Util.case(over.bowler.name, t_id)
            temp["wickets"] = Array.new(over.wickets, 1)
            overs_list << temp

        end

        hash["tour"] = Match.find(m_id).get_tour_font
        hash["color"] = Util.get_team_color(t_id, team.abbrevation)
        hash["teamname"] = team.get_teamname
        hash["overs"] = overs_list
        render(:json => Oj.dump(hash))
    end

    def partnerships
        m_id = params[:m_id]
        inn_no = params[:inn_no]

        inn = Inning.find_by(match_id: m_id, inn_no: inn_no)
        t_id = inn.tournament_id
        team = inn.bat_team

        hash = {}
        list = []
        partnerships = Partnership.where(inning_id: inn.id)
        partnerships.each do |partnership|
            temp = {}
            temp["runs"] = partnership.runs
            temp["balls"] = partnership.balls
            temp["b1"] = Util.case(Player.find(partnership.batsman1_id).name, t_id)
            temp["b1s"] = partnership.b1s
            temp["b1b"] = partnership.b1b
            temp["b2"] = Util.case(Player.find(partnership.batsman2_id).name, t_id)
            temp["b2s"] = partnership.b2s
            temp["b2b"] = partnership.b2b
            list << temp
        end
        hash["tour"] = Match.find(m_id).get_tour_font
        hash["color"] = Util.get_team_color(t_id, team.abbrevation)
        hash["teamname"] = team.get_teamname
        hash["partnerships"] = list
        render(:json => Oj.dump(hash))
    end

    def matches
        t_id = params[:t_id]
        p_id = params[:p_id]
        venue = params[:venue]
        tour_class = params[:tour_class]
        array = []
        if tour_class
            t_ids = Tournament.where(name: tour_class).pluck(:id)
            matches = Match.where(tournament_id: t_ids).order(id: :desc)
        elsif t_id
            matches = Match.where(tournament_id: t_id).order(id: :desc)
        elsif p_id
            matches = Performance.where(player_id: p_id).order(id: :desc)
        elsif venue
            matches = Match.where(venue: venue).order(id: :desc)
        else
            matches = Match.all.order(id: :desc)
        end
        matches.each do|match|
            array << match.match_box
        end
        render(:json => Oj.dump(array))
    end

    def worm
        hash = {}
        m_id = params[:m_id].to_i
        inn1_id = (2*m_id) - 1
        inn1 = Inning.find(inn1_id)
        inn1_hash = inn1.get_worm_details
        inn2 = Inning.find(inn1_id+1)
        inn2_hash = inn2.get_worm_details

        hash['inn1'] = inn1_hash
        hash['inn2'] = inn2_hash
        hash['tour_font'] = inn1.match.tournament.get_tour_font

        render(:json => Oj.dump(hash))
    end

    def commentry
        overs_arr = []
        ret_hash = {}
        m_id = params[:m_id].to_i
        inn_no = params[:inn_no].to_i
        inn_id = (2*m_id) - 2 + inn_no
        inn = Inning.find(inn_id)
        t_id = inn.tournament_id
        overs = Over.where(inning_id: inn_id)
        ret_hash['bat_team_color'] = Util.get_team_color(t_id, inn.bat_team.abbrevation)
        ret_hash['bow_team_color'] = Util.get_team_color(t_id, inn.bow_team.abbrevation)
        if inn_no == 2
            target = Inning.find(inn_id-1).score + 1
            inn1_over_scores = Over.where(inning_id: inn_id-1).pluck(:score)
            inn2_over_scores = overs.pluck(:score)
            team_color1 = ret_hash['bow_team_color']
            team_color2 = ret_hash['bat_team_color']
        else
            inn1_over_scores = overs.pluck(:score)
            inn2_over_scores = Over.where(inning_id: inn_id+1).pluck(:score)
            team_color2 = ret_hash['bow_team_color']
            team_color1 = ret_hash['bat_team_color']
        end
        max_length = [inn1_over_scores.length, inn2_over_scores.length].max
        inn1_over_scores = InningHelper.adjust_array_length(inn1_over_scores, 20)
        inn2_over_scores = InningHelper.adjust_array_length(inn2_over_scores, 20)
        percentage_array = InningHelper.calculate_percentage_array(inn1_over_scores, inn2_over_scores)
        percentages = []

        percentage_array.each do|arr|
            temp1 = {
              "color" => team_color1,
              "value" => arr[0]
            }
            temp2 = {
              "color" => team_color2,
              "value" => arr[1]
            }
            percentages << [temp1, temp2]
        end
        batsman_hash = {}
        scores_arr = []
        bowler_hash = {}
        wicket_count = 0
        scores = inn.scores.where(batted: true).order(position: :asc)
        scores.each do |score|
            temp1 = {}
            temp1['name'] = Util.case(score.player.name, t_id)
            temp1['runs'] = 0
            temp1['balls'] = 0
            scores_arr << temp1
        end
        batsman_hash[scores_arr[0]['name']] = scores_arr[0]
        batsman_hash[scores_arr[1]['name']] = scores_arr[1]
        overs.each do|over|
            hash = {}
            hash['over_no'] = over.over_no
            hash['runs'] = over.runs
            hash['score'] = "#{over.score} - #{over.for}"
            over_delivery = (over.over_no - 1 + ((over.balls) * 0.1)).round(1)
            hash['cur_rr'] = Util.get_rr(over.score,Util.overs_to_balls(over_delivery))
            if inn_no == 2
                hash['req_rr'] = Util.get_rr((target - over.score), 120 - Util.overs_to_balls(over_delivery))
                hash['p_teamname2'] = inn.bat_team.get_abb
                hash['p_teamname1'] = inn.bow_team.get_abb
            else
                hash['p_teamname1'] = inn.bat_team.get_abb
                hash['p_teamname2'] = inn.bow_team.get_abb
            end
            hash['teamname'] = inn.bat_team.get_abb

            ball_arr = []
            sequence = []
            balls = Ball.where(over_id: over.id)
            balls.each do|ball|
                ball_hash = {}
                ball_hash['delivery'] = ball.delivery
                ball_hash['batsman'] = Util.case(ball.batsman.name, t_id)
                ball_hash['bowler'] = Util.case(ball.bowler.name, t_id)
                ball_hash['result'], ball_hash['tag'] = ball.get_result_and_tag
                ball_hash['delivery'] = ball.delivery
                sequence << ball_hash['result']
                ball_arr << ball_hash
                if batsman_hash.has_key? ball_hash['batsman']
                    temp = batsman_hash[ball_hash['batsman']]
                    temp["runs"] += ball.runs
                    temp["balls"] += 1 unless ball.extra_type == "wd"
                else
                    raise StandardError.new("❌ match_controller#commentry: error")
                end
                if ball.wicket_ball
                    wicket_count += 1
                    batsman_hash.delete(ball_hash['batsman'])
                    if wicket_count < 10
                        new_batter = scores_arr[wicket_count+1]
                        batsman_hash[new_batter['name']] = new_batter
                    end
                end
            end
            hash['sequence'] = sequence.join(' ')
            hash['balls'] = ball_arr
            hash['batsman1'] = batsman_hash[batsman_hash.keys[0]].dup
            if wicket_count < 10
                hash['batsman2'] = batsman_hash[batsman_hash.keys[1]].dup
            end
            bowler = Util.case(over.bowler.name, t_id)
            if bowler_hash.keys.include? bowler
                bowler_hash[bowler]["wickets"] += over.wickets
                bowler_hash[bowler]["runs"] += over.bow_runs
                bowler_hash[bowler]["overs"] = Util.balls_to_overs(Util.overs_to_balls(bowler_hash[bowler]["overs"]) + over.balls)
            else
                bowler_hash[bowler] = {
                  "name" => bowler,
                  "wickets" => over.wickets,
                  "runs" => over.bow_runs,
                  "overs" => Util.balls_to_overs(over.balls)
                }
            end
            hash['bowler'] = bowler_hash[bowler].dup
            overs_arr << hash
        end
        ret_hash['tour_font'] = inn.tournament.get_tour_font
        ret_hash['percentages'] = percentages
        ret_hash['overs'] = overs_arr
        render(:json => Oj.dump(ret_hash))
    end

    def innings_progression
        m_id = params[:m_id]
        match = Match.find(m_id)
        hash = {}
        innings_progression = {}
        innings_progression['powerplay'] = [ Match.innings_progression_hash(match.inn1, 'powerplay'), Match.innings_progression_hash(match.inn2, 'powerplay')]
        innings_progression['middle'] = [ Match.innings_progression_hash(match.inn1, 'middle'), Match.innings_progression_hash(match.inn2, 'middle')]
        innings_progression['death'] = [ Match.innings_progression_hash(match.inn1, 'death'), Match.innings_progression_hash(match.inn2, 'death')]
        hash['innings_progression'] = innings_progression
        performers = {}

        performers['inn1'] = Match.get_inn_hash_for_phase_performers(match.inn1, innings_progression)
        performers['inn2'] = Match.get_inn_hash_for_phase_performers(match.inn2, innings_progression)
        hash['performers'] = performers
        hash['tour_font'] = match.tournament.get_tour_font
        render(:json => Oj.dump(hash))
    end
end
