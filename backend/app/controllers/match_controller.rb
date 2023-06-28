
class MatchController < ApplicationController
    def summary
        m_id = params[:m_id]

        match = Match.find(m_id)
        hash = {}
        toss = match.toss_id
        hash["inn1"] = get_innings_summary((2*m_id.to_i)-1, toss)
        hash["inn2"] = get_innings_summary(2*m_id.to_i, toss)
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
        footer["result_color"] = "#{Squad.find(match.winner_id).abbrevation}"

        motm = {}
        motm["name"] = Util.case(match.motm.fullname, match.tournament_id)
        motm["pid"] = match.motm_id
        motm["color"] = Squad.find(Performance.find_by(player: match.motm_id, match_id: m_id).squad_id).abbrevation
        score = Score.where(match_id: m_id, player_id: match.motm_id).first
        if score.batted
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
        render(:json => Oj.dump(hash))
    end

    def get_innings_summary(inn_id, toss)
        hash = {}
        inn = Inning.find(inn_id)
        m_id = inn.match_id
        hash["teamname"] = inn.bat_team_id == toss ? "#{inn.bat_team.get_teamname} 🪙" : inn.bat_team.get_teamname
        hash["bat_team"] = Squad.find(inn.bat_team_id).abbrevation
        hash["bow_team"] = Squad.find(inn.bow_team_id).abbrevation
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
        header["color"] = team.abbrevation
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
        hash["color"] = "#{team.abbrevation}"
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
        hash["color"] = "#{team.abbrevation}"
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
        hash["color"] = "#{team.abbrevation}"
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
        hash["color"] = "#{team.abbrevation}"
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
            m_ids = Match.where(tournament_id: t_ids).order(id: :desc).pluck(:id)
        elsif t_id
            m_ids = Match.where(tournament_id: t_id).order(id: :desc).pluck(:id)
        elsif p_id
            m_ids = Performance.where(player_id: p_id).order(id: :desc).pluck(:match_id)
        elsif venue
            m_ids = Match.where(venue: venue).order(id: :desc).pluck(:id)
        else
            m_ids = Match.all.order(id: :desc).pluck(:id)
        end
        m_ids.each do|m_id|
            array << Match.match_box(m_id)
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

        render(:json => Oj.dump(hash))
    end
end
