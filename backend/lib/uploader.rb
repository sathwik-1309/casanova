module Uploader
    def self.match
        CSV.foreach(MATCH_CSV_PATH + "/match.csv", headers: true) do |row|
            m = Match.new
            m.id = row["id"]
            m.stage = row["stage"]
            m.venue = row["venue"]
            m.ball_color1 = row["ball_color1"]
            m.ball_color2 = row["ball_color2"]
            m.pitch = row["pitch"]
            m.tournament_id = row["t_id"]
            m.inn1_id = row["inn1_id"]
            m.inn2_id = row["inn2_id"]
            m.winner_id = row["winner_id"]
            m.loser_id = row["loser_id"]
            m.motm_id = row["motm_id"]
            m.toss_id = row["toss_id"]
            unless m.save
                puts "match error ❌"
                puts m.errors.full_messages
                puts "match error end ❌"
                return false
            end
        end
        return true
    end

    def self.update_match
        m_id = Match.last.id
        m = Match.find(m_id)
        innings = Inning.where(match_id: m_id)
        wides, no_balls, extras, dots, c1, c2, c3, c4, c6 = 0,0,0,0,0,0,0,0,0
        runs, wickets = 0,0
        innings.each do |inn|
            wides += inn.wides
            no_balls += inn.no_balls
            extras += inn.extras
            dots += inn.dots
            c1 += inn.c1
            c2 += inn.c2
            c3 += inn.c3
            c4 += inn.c4
            c6 += inn.c6
            runs += inn.score
            wickets += inn.for
        end
        m.extras = extras
        m.wides = wides
        m.no_balls = no_balls
        m.dots = dots
        m.c1 = c1
        m.c2 = c2
        m.c3 = c3
        m.c4 = c4
        m.c6 = c6
        m.runs = runs
        m.wickets = wickets
        if m.inn1.bat_team_id == m.winner_id
            m.win_by_runs = m.inn1.score - m.inn2.score
        else
            m.win_by_wickets = 10 - m.inn2.for
        end
        unless m.save
            puts "match update error ❌"
            puts m.errors.full_messages
            puts "match update error end ❌"
            return false
        end
        return true
    end

    def self.innings
        CSV.foreach(MATCH_CSV_PATH + "/innings.csv", headers: true) do |row|
            i = Inning.new
            i.id = row["id"]
            i.inn_no = row["inn_no"]
            i.overs = row["overs"]
            i.score = row["score"]
            i.for = row["for"]
            i.ball_color1 = row["ball_color1"]
            i.ball_color2 = row["ball_color2"]
            i.match_id = row["m_id"]
            i.tournament_id = row["t_id"]
            i.bat_team_id = row["bat_team_id"]
            i.bow_team_id = row["bow_team_id"]
            unless i.save
                puts "inning error ❌"
                puts i.errors.full_messages
                puts "inning error end ❌"
                return false
            end
        end
        return true
    end

    def self.update_innings
        m_id = Match.last.id
        innings = Inning.where(match_id: m_id)
        innings.each do |inn|
            wides, no_balls, extras, dots, c1, c2, c3, c4, c6 = 0,0,0,0,0,0,0,0,0
            overs = Over.where(inning_id: inn.id)
            overs.each do|over|
                wides += over.wides
                no_balls += over.no_balls
                extras += over.extras
                dots += over.dots
                c1 += over.c1
                c2 += over.c2
                c3 += over.c3
                c4 += over.c4
                c6 += over.c6
            end
            inn.extras = extras
            inn.wides = wides
            inn.no_balls = no_balls
            inn.dots = dots
            inn.c1 = c1
            inn.c2 = c2
            inn.c3 = c3
            inn.c4 = c4
            inn.c6 = c6
            unless inn.save
                puts "inn update error ❌"
                puts inn.errors.full_messages
                puts "inn update error end ❌"
                return false
            end
        end
        return true
    end

    def self.overs
        CSV.foreach(MATCH_CSV_PATH + "/overs.csv", headers: true) do |row|
            o = Over.new
            o.id = row["id"]
            o.over_no = row["over_no"]
            o.score = row["score"]
            o.for = row["for"]
            o.ball_color = row["ball_color"]
            o.bowler_id = row["bowler_id"]
            o.inning_id = row["inn_id"]
            o.match_id = row["m_id"]
            o.tournament_id = row["t_id"]
            unless o.save
                puts "over error ❌"
                puts o.errors.full_messages
                puts "over error end ❌"
                return false
            end
        end
        return true
    end

    def self.update_overs
        m_id = Match.last.id
        overs = Over.where(match_id: m_id)
        overs.each do|over|
            balls = Ball.where(over_id: over.id, extra_type: [nil, "lb", "b"])
            over.balls = balls.length
            runs, bow_runs, wickets, wides, no_balls, extras, dots, c1, c2, c3, c4, c6 = 0,0,0,0,0,0,0,0,0,0,0,0
            balls.each do |ball|
                runs += ball.extras + ball.runs
                bow_runs += ball.bow_runs
                extras += ball.extras
                if ball.wicket_ball
                    wickets += 1
                end
                if ball.extra_type == 'wd'
                    wides += extras
                end
                if ball.extra_type == 'nb'
                    no_balls += 1
                end

                if ball.category == "c0"
                    dots += 1
                elsif ball.category == "c1"
                    c1 += 1
                elsif ball.category == "c2"
                    c2 += 1
                elsif ball.category == "c3"
                    c3 += 1
                elsif ball.category == "c4"
                    c4 += 1
                elsif ball.category == "c6"
                    c6 += 1
                end
            end
            over.runs = runs
            over.bow_runs = bow_runs
            over.wickets = wickets
            over.extras = extras
            over.wides = wides
            over.no_balls = no_balls
            over.dots = dots
            over.c1 = c1
            over.c2 = c2
            over.c3 = c3
            over.c4 = c4
            over.c6 = c6
            # print [dots,c1,c2,c3,c4,c6]
            unless over.save
                puts "over error ❌"
                puts over.errors.full_messages
                puts "over error end ❌"
                return false
            end
        end
        return true
    end

    def self.balls
        CSV.foreach(MATCH_CSV_PATH + "/balls.csv", headers: true) do |row|
            b = Ball.new
            b.id = row["id"]
            b.runs = row["runs"]
            b.extras = row["extras"]
            if row["extra_type"] != "nil"
                b.extra_type = row["extra_type"]
            end
            if row["category"] != "nil"
                b.category = row["category"]
            end
            b.delivery = row["delivery"]
            b.wicket_ball = row["wicket_ball"]
            b.score = row["score"]
            b.for = row["for"]
            b.bow_runs = row["bow_runs"]
            b.ball_color = row["ball_color"]
            b.batsman_id = row["batsman_id"]
            b.bowler_id = row["bowler_id"]
            b.over_id = row["o_id"]
            b.inning_id = row["inn_id"]
            b.match_id = row["m_id"]
            b.tournament_id = row["t_id"]
            unless b.save
                puts "ball error ❌"
                puts b.errors.full_messages
                puts "ball error end ❌"
                return false
            end
        end
        return true
    end

    def self.wickets
        CSV.foreach(MATCH_CSV_PATH + "/wickets.csv", headers: true) do |row|
            w = Wicket.new
            w.id = row["id"]
            w.method = row["method"]
            w.ball_id = row["b_id"]
            w.over_id = row["o_id"]
            w.inning_id = row["inn_id"]
            w.match_id = row["m_id"]
            w.tournament_id = row["t_id"]
            w.batsman_id = row["batsman_id"]
            w.bowler_id = row["bowler_id"]
            w.fielder_id = row["fielder_id"]
            w.delivery = row["delivery"]
            unless w.save
                puts "wicket error ❌"
                puts w.errors.full_messages
                puts "wicket error end ❌"
                return false
            end
        end
        return true
    end

    def self.scores
        CSV.foreach(MATCH_CSV_PATH + "/scores.csv", headers: true) do |row|
            s = Score.new
            s.id = row["id"]
            s.runs = row["runs"]
            s.balls = row["balls"]
            s.position = row["position"]
            s.not_out = row["not_out"]
            s.batted = row["batted"]
            s.dots = row["c0"]
            s.c1 = row["c1"]
            s.c2 = row["c2"]
            s.c3 = row["c3"]
            s.c4 = row["c4"]
            s.c6 = row["c6"]
            s.player_id = row["player_id"]
            s.squad_id = row["squad_id"]
            s.inning_id = row["inning_id"]
            s.match_id = row["match_id"]
            s.tournament_id = row["tournament_id"]
            unless s.save
                puts "score error ❌"
                puts s.errors.full_messages
                puts "score error end ❌"
                return false
            end
        end
        return true
    end

    def self.update_scores
        m_id = Match.last.id
        scores = Score.where(match_id: m_id).where(batted: true)
        scores.each do|score|
            score.sr = Util.get_sr(score.runs, score.balls)
            score.save
            unless score.save
                puts "score update error ❌"
                puts score.errors.full_messages
                puts "score update error end ❌"
                return false
            end
        end
        return true
    end

    def self.spells
        CSV.foreach(MATCH_CSV_PATH + "/spells.csv", headers: true) do |row|
            s = Spell.new
            s.id = row["id"]
            s.runs = row["runs"]
            s.overs = row["overs"]
            s.wickets = row ["wickets"]
            s.player_id = row["player_id"]
            s.squad_id = row["squad_id"]
            s.inning_id = row["inning_id"]
            s.match_id = row["match_id"]
            s.tournament_id = row["tournament_id"]
            unless s.save
                puts "spell error ❌"
                puts s.errors.full_messages
                puts "spell error end ❌"
                return false
            end
        end
        return true
    end

    def self.update_spells
        m_id = Match.last.id
        spells = Spell.where(match_id: m_id)
        spells.each do|spell|
            maiden_overs = spell.get_overs.where(runs: 0, extras: 0)
            maidens = 0
            maiden_overs.each do |over|
                if over.balls == 6
                    maidens += 1
                end
            end
            spell.maidens = maidens
            spell.economy = Util.get_economy(spell.runs, spell.overs)
            if spell.wickets != 0
                spell.sr = Util.get_bow_sr(spell.overs, spell.wickets)
                spell.avg = Util.get_bow_avg(spell.runs, spell.wickets)
            end
            spell.wides = spell.get_overs.pluck(:wides).sum
            spell.no_balls = spell.get_overs.pluck(:no_balls).sum
            spell.dots = spell.get_overs.pluck(:dots).sum
            spell.c1 = spell.get_overs.pluck(:c1).sum
            spell.c2 = spell.get_overs.pluck(:c2).sum
            spell.c3 = spell.get_overs.pluck(:c3).sum
            spell.c4 = spell.get_overs.pluck(:c4).sum
            spell.c6 = spell.get_overs.pluck(:c6).sum
            unless spell.save
                puts "spell update error ❌"
                puts spell.errors.full_messages
                puts "spell update error end ❌"
                return false
            end
        end
        return true
    end

    def self.partnerships
        CSV.foreach(MATCH_CSV_PATH + "/partnerships.csv", headers: true) do |row|
            p = Partnership.new
            p.id = row["id"]
            p.runs = row["runs"]
            p.balls = row["balls"]
            p.dots = row["c0"]
            p.c1 = row["c1"]
            p.c2 = row["c2"]
            p.c3 = row["c3"]
            p.c4 = row["c4"]
            p.c6 = row["c6"]
            p.for_wicket = row ["for_wicket"]
            p.not_out = row["not_out"]
            p.b1s = row["b1s"]
            p.b2s = row["b2s"]
            p.b1b = row["b1b"]
            p.b2b = row["b2b"]
            p.inning_id = row["inn_id"]
            p.match_id = row["m_id"]
            p.tournament_id = row["t_id"]
            p.batsman1_id = row["b1"]
            p.batsman2_id = row["b2"]
            p.bat_team_id = row["bat_team_id"]
            p.bow_team_id = row["bow_team_id"]
            unless p.save
                puts "Partnership error ❌"
                puts p.errors.full_messages
                puts "Partnership error end ❌"
                return false
            end
        end
        return true
    end

    def self.update_partnerships
        m_id = Match.last.id
        parts = Partnership.where(match_id: m_id)
        parts.each do|part|
            part.sr = Util.get_sr(part.runs, part.balls)
            unless part.save
                puts "Partnership update error ❌"
                puts part.errors.full_messages
                puts "Partnership update error end ❌"
                return false
            end
        end
        return true
    end

    def self.update_bat_stats(match)
        scores = match.scores
        scores.each do|score|
            sub_types = ["overall", "#{score.tournament.name}", "tour_#{score.tournament.id}", "#{score.squad.team.abbrevation}"]
            sub_types.each do|sub_type|
                b = BatStat.find_by(player_id: score.player_id, sub_type: sub_type)
                if b.nil?
                    b = BatStat.create_db_entry(score.player_id, sub_type)
                    raise StandardError if b.nil?
                end
                if score.batted
                    status = Uploader.update_bat_stats_entry(b, score)
                    raise StandardError unless status
                end
                b.matches += 1
                b.save!
            end
        end
        return true
    end

    def self.update_ball_stats(match)
        spells = match.spells
        spells.each do|spell|
            sub_types = ["overall", "#{spell.tournament.name}", "tour_#{spell.tournament.id}", "#{spell.squad.team.abbrevation}"]
            sub_types.each do|sub_type|
                b = BallStat.find_by(player_id: spell.player_id, sub_type: sub_type)
                if b.nil?
                    b = BallStat.create_db_entry(spell.player_id, sub_type)
                    raise StandardError if b.nil?
                end
                status = Uploader.update_ball_stats_entry(b, spell, sub_type)
                raise StandardError unless status
            end
        end
        return true
    end

    def self.performances_and_player_matches
        CSV.foreach(MATCH_CSV_PATH + "/performances.csv", headers: true) do |row|
            p = Performance.new
            p.id = row["id"]
            p.won = row["won"]
            p.captain = row["captain"]
            p.keeper = row["keeper"]
            p.match_id = row["match_id"]
            p.tournament_id = row["tournament_id"]
            p.player_id = row["player_id"]
            p.squad_id = row["squad_id"]
            unless p.save
                puts "Performance error ❌"
                puts p.errors.full_messages
                puts "Performance error end ❌"
                return false
            end
            # player = Player.find(p.player_id)
            # player.matches += 1
            # unless player.save
            #     puts "Player update error ❌"
            #     puts player.errors.full_messages
            #     puts "Player update error end ❌"
            #     return false
            # end
        end
        return true
    end

    def self.update_squads_and_teams
        m_id = Match.last.id
        match = Match.last
        sq_1 = Squad.find(match.winner_id)
        sq_2 = Squad.find(match.loser_id)
        t1 = Team.find(sq_1.team_id)
        t2 = Team.find(sq_2.team_id)

        sq_1.matches += 1
        sq_1.won += 1
        t1.matches += 1
        t1.won += 1

        sq_2.matches += 1
        sq_2.lost += 1
        t2.matches += 1
        t2.lost += 1

        innings = Inning.where(match_id: m_id)
        innings.each do|inn|
            if inn.bat_team_id == sq_1.id
                sq_1.runs += inn.score
                sq_1.wickets_lost += inn.for
                sq_2.runs_conceded += inn.score
                sq_2.wickets += inn.for
                t1.runs += inn.score
                t1.wickets_lost += inn.for
                t2.runs_conceded += inn.score
                t2.wickets += inn.for

            else
                t2.runs += inn.score
                t2.wickets_lost += inn.for
                t1.runs_conceded += inn.score
                t1.wickets += inn.for
            end
            sq_1.nrr = sq_1.get_nrr
            sq_2.nrr = sq_2.get_nrr
        end
        unless sq_1.save
            puts "sq_1 update error ❌"
            puts sq_1.errors.full_messages
            puts "sq_1 update error end ❌"
            return false
        end
        unless sq_2.save
            puts "sq_2 update error ❌"
            puts sq_2.errors.full_messages
            puts "sq_2 update error end ❌"
            return false
        end
        unless t1.save
            puts "t1 update error ❌"
            puts t1.errors.full_messages
            puts "t1 update error end ❌"
            return false
        end
        unless t2.save
            puts "t2 update error ❌"
            puts t2.errors.full_messages
            puts "t2 update error end ❌"
            return false
        end
        return true
    end

    def self.increment_player_trophies(match)
        player = match.motm
        player.trophies['motm'] += 1
        player.save!
        if match.stage == 'final'
            player.trophies['gem'] += 1
            player.save!
            tour = match.tournament
            pots_p = tour.pots
            pots_p.trophies['pots'] += 1
            pots_p.save!
            mvp_p = tour.mvp
            mvp_p.trophies['mvp'] += 1
            mvp_p.save!
            most_runs_p = tour.most_runs
            most_runs_p.trophies['most_runs'] += 1
            most_runs_p.save!
            most_wickets_p = tour.most_wickets
            most_wickets_p.trophies['most_wickets'] += 1
            most_wickets_p.save!
            Uploader.increment_player_medals(tour)
        end
        return true
    end

    def self.increment_player_medals(tour)
        file = File.read(TOURNAMENT_JSON_PATH)
        data = JSON.parse(file)
        t_json = data.find{|t| t['id'] == tour.id}
        gold_id = t_json['medals']['gold']
        squad_players = SquadPlayer.where(squad_id: gold_id)
        Uploader.update_players_medals(squad_players, 'gold')
        silver_id = t_json['medals']['silver']
        squad_players = SquadPlayer.where(squad_id: silver_id)
        Uploader.update_players_medals(squad_players, 'silver')
        bronze_id = t_json['medals']['bronze']
        squad_players = SquadPlayer.where(squad_id: bronze_id)
        Uploader.update_players_medals(squad_players, 'bronze')
    end

    def self.upload_match
        status_list = []
        status_list << Uploader.match
        status_list << Uploader.innings
        status_list << Uploader.overs
        status_list << Uploader.balls
        status_list << Uploader.wickets
        status_list << Uploader.scores
        status_list << Uploader.spells
        status_list << Uploader.partnerships
        status_list << Uploader.update_overs
        status_list << Uploader.update_innings
        status_list << Uploader.performances_and_player_matches
        status_list << Uploader.update_scores
        status_list << Uploader.update_spells
        status_list << Uploader.update_match
        # handled in match after commit hook
        # status_list << Uploader.update_bat_stats
        # status_list << Uploader.update_ball_stats
        # status_list << Uploader.increment_player_motm
        status_list << Uploader.update_partnerships
        status_list << Uploader.update_squads_and_teams

        if status_list.include? false
            puts "Uploader# Model.save error exists ❌"
            return false
        else
            puts "Uploader# Match upload successfull ✅"
            return true
        end
    end

    def self.update_tournament_after_final(match)
        file = File.read(TOURNAMENT_JSON_PATH)
        tours = JSON.parse(file)
        tour = tours.select { |tour| tour['id'] == match.tournament_id} [0]
        raise StandardError.new("❌ Uploader#update_tournament_after_final: tour not found in tournaments.json") if tour.nil?
        t = Tournament.find(match.tournament_id)
        medals = {}
        tour_medals = tour['medals']
        medals['gold'] = tour_medals['gold']
        medals['silver'] = tour_medals['silver']
        medals['bronze'] = tour_medals['bronze']
        t.medals = medals
        t.pots_id = tour['pots_id']
        t.mvp_id = tour['mvp_id']
        t.most_runs_id = tour['most_runs_id']
        t.most_wickets_id = tour['most_wickets_id']
        t.ongoing = false
        t.save!
    end

    private

    def self.update_bat_stats_entry(b, score)
        b.innings += 1
        b.runs += score.runs
        b.balls += score.balls
        b.not_outs += 1 if score.not_out
        b.avg = Util.get_avg(b.runs, b.innings - b.not_outs) if b.innings - b.not_outs > 0
        b.sr = Util.get_sr(b.runs, b.balls)
        b.dots += score.dots
        b.c1 += score.c1
        b.c2 += score.c2
        b.c3 += score.c3
        b.c4 += score.c4
        b.c6 += score.c6
        b.thirties += 1 if score.runs >= 30
        b.fifties += 1 if score.runs >= 50
        b.hundreds += 1 if score.runs >= 100
        b.boundary_p = Util.get_boundary_p(b.c4, b.c6, b.balls)
        b.dot_p = Util.get_dot_p(b.dots, b.balls)
        if b.best.nil?
            b.best_id = score.inning_id
        else
            b.best_id = score.inning_id if b.best.runs < score.runs
            b.best_id = score.inning_id if (b.best.runs == score.runs and b.best.balls > score.balls)
        end
        b.save!
        return true
    end

    def self.update_ball_stats_entry(b, spell, sub_type)
        bat_stat = BatStat.find_by(player_id: b.player_id, sub_type: sub_type)
        raise StandardError if bat_stat.nil?
        bat_stat.reload
        b.matches = bat_stat.matches
        b.innings += 1
        b.overs = Util.balls_to_overs(Util.overs_to_balls(spell.overs)+Util.overs_to_balls(b.overs))
        b.maidens += spell.maidens
        b.runs += spell.runs
        b.wickets += spell.wickets
        b.economy = Util.get_economy(b.runs, b.overs)
        if b.wickets > 0
            b.avg = Util.get_bow_avg(b.runs, b.wickets)
            b.sr = Util.get_bow_sr(b.overs, b.wickets)
        end
        b.wides += spell.wides
        b.no_balls += spell.no_balls
        b.dots += spell.dots
        b.c1 += spell.c1
        b.c2 += spell.c2
        b.c3 += spell.c3
        b.c4 += spell.c4
        b.c6 += spell.c6
        b.three_wickets += 1 if spell.wickets >= 3
        b.five_wickets += 1 if spell.wickets >= 5
        b.boundary_p = Util.get_boundary_p(b.c4, b.c6, Util.overs_to_balls(b.overs))
        b.dot_p = Util.get_dot_p(b.dots, Util.overs_to_balls(b.overs))
        b.best_id = spell.inning_id if b.best.nil? or b.best.wickets < spell.wickets
        b.best_id = spell.inning_id if b.best.nil? or (b.best.wickets == spell.wickets and b.best.economy > spell.economy)
        unless b.save
            puts "ball_stats update error ❌"
            puts b.errors.full_messages
            puts "ball_stats update error end ❌"
            return false
        end
        return true
    end

    def self.update_milestone_image(match)
        new_image = Milestone.get_new_milestone_image(match)
        m = MilestoneImage.new
        m.image = new_image
        m.match_id = match.id
        m.tournament_id = match.tournament_id
        unless m.save
            puts m.errors.full_messages
            puts "❌ Uploader#update_milestone_image: Failed to update ml image"
            return false
        end
        return true
    end

    def self.add_new_milestone(m)
        unless m.save
            puts m.errors.full_messages
            puts "❌ Uploader#add_new_milestone: Failed to add ml"
            return false
        end
        return true
    end

    def self.update_players_medals(squad_players, medal)
        squad_players.each do|squad_player|
            player = squad_player.player
            player.trophies[medal] += 1
            player.save!
        end
    end

    # def self.update_player_matches(match)
    #     scores = match.scores
    #     scores.each do |score|
    #         p = score.player
    #         p.matches += 1
    #         p.save!
    #     end
    # end

    # def self.update_milestones(match, prev_image, new_image)
    #
    # end
end

