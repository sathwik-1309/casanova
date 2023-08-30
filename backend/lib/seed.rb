require 'csv'
require "#{Dir.pwd}/lib/new"
module Seed

    def self.add_tournaments
        CSV.foreach(SEED_CSV_PATH + '/tournaments.csv', headers: true) do |row|
            tournament = Tournament.new
            tournament.name = row['name']
            tournament.season = row['season']
            tournament.id = row['id']
            tournament.ongoing = true
            tournament.save
        end
        puts "Tournament added"
    end

    # not used anymore, moved to match hook
    # def self.update_tournaments
    #     CSV.foreach(SEED_CSV_PATH + '/tournaments.csv', headers: true) do |row|
    #         if row['id']!='6'
    #             tournament = Tournament.find(row['id'])
    #             tournament.winners_id = Squad.find_by(team_id: row['winners_team_id'], tournament_id: row['id']).id
    #             tournament.runners_id = Squad.find_by(team_id: row['runners_team_id'], tournament_id: row['id']).id
    #             tournament.pots_id = row['pots_id']
    #             tournament.mvp_id = row['mvp_id']
    #             tournament.most_runs_id = row['most_runs_id']
    #             tournament.most_wickets_id = row['most_wickets_id']
    #             tournament.save
    #         end
    #     end
    #     puts "Tournament updated"
    # end

    def self.add_teams
        CSV.foreach(SEED_CSV_PATH + '/teams.csv', headers: true) do |row|
            teams = Team.new
            teams.name = row['name']
            teams.abbrevation = row['abb']
            teams.id = row['id']
            teams.save
        end
        puts "Teams added"
    end

    def self.update_teams
        teams = Team.all
        teams.each do|team|
            mat = 0
            won = 0
            lost = 0
            runs = 0
            wickets = 0
            runs_conceded = 0
            wickets_lost = 0
            team.squads.each do|squad|
                mat += squad.matches
                runs += squad.runs
                won += squad.won
                lost += squad.lost
                wickets += squad.wickets
                runs_conceded += squad.runs_conceded
                wickets_lost += squad.wickets_lost
            end
            team.matches = mat
            team.runs = runs
            team.won = won
            team.lost = lost
            team.wickets = wickets
            team.runs_conceded = runs_conceded
            team.wickets_lost = wickets_lost
            team.save
        end
        puts "Teams updated"
    end

    def self.add_squads
        CSV.foreach(SEED_CSV_PATH + '/squads.csv', headers: true) do |row|
            squad = Squad.new
            squad.name = row['name']
            squad.abbrevation = row['abb']
            squad.team_id = row['team_id']
            squad.tournament_id = row['tournament_id']
            squad.captain_id = row['captain']
            squad.keeper_id = row['keeper_id']
            squad.save
            # nrr
        end
        puts "Squads Added"
    end

    def self.update_squads
        squads = Squad.all
        squads.each do|squad|
            won = 0
            lost = 0
            mat = 0
            runs = 0
            wickets = 0
            runs_conceded = 0
            wickets_lost = 0
            matches = squad.matches_list
            matches.each do |match|
                if match.winner_id == squad.id
                    won+=1
                else
                    lost+=1
                end
                mat+=1
                inning = Inning.find_by(match_id: match.id, bat_team_id: squad.id)
                unless inning.nil?
                    runs += inning.score
                    wickets_lost += inning.for
                end
                inning = Inning.find_by(match_id: match.id, bow_team_id: squad.id)
                unless inning.nil?
                    runs_conceded += inning.score
                    wickets += inning.for
                end
            end
            squad.matches = mat
            squad.won = won
            squad.lost = lost
            squad.runs = runs
            squad.wickets = wickets
            squad.runs_conceded = runs_conceded
            squad.wickets_lost = wickets_lost
            squad.nrr = squad.get_nrr
            squad.save
        end
        puts "Squads updated"
    end

    def self.add_players
        CSV.foreach(SEED_CSV_PATH + '/players.csv', headers: true) do |row|
            player = Player.new
            player.id = row['id']
            player.fullname = row['fullname']
            player.skill = row['skill']
            player.batting_hand = row['batting_hand']
            if row['bowling_hand']!='0'
                player.bowling_hand = row['bowling_hand']
                player.bowling_style = row['bowling_style']
            end
            player.country_team_id = row['country']
            trophies = PLAYER_TROPHIES_INIT
            player.trophies = trophies
            player.save
            # name
            # ipl_team_id
            # csl_team_id

            # matches
            # keeper
        end
        puts "Player Added"
    end

    def self.update_players
        CSV.foreach(SEED_CSV_PATH + '/name.csv') do |row|
            id = row[-1]
            name = row[2]
            csl_team_id = row[-2]
            ipl_team_id = row[-3]
            player = Player.find(id)
            player.name = name
            if csl_team_id!='0'
                player.csl_team_id = csl_team_id
            end
            if ipl_team_id!='0'
                player.ipl_team_id = ipl_team_id
            end
            player.save
            # matches
            # keeper
        end
        puts "Player Updated"
    end

    # deprecated, moved to add_new_players
    # def self.update_players_born
    #     players = Player.all
    #     players.each do|player|
    #         id = player.id
    #         csv_file = File.read(SEED_CSV_PATH + '/born.csv')
    #         csv_data = CSV.parse(csv_file)
    #         line = csv_data[id-1]
    #         born = line[0]
    #         born = Team.find_by(abbrevation: born).id
    #         player.born_team_id = born
    #         player.save
    #     end
    #     puts "Players updated born"
    # end

    def self.update_players_keeper
        all_players = Player.all.pluck(:id)
        all_players.each do|player_id|
            player = Player.find(player_id)
            player.keeper = false
            player.save
        end
        pl_list = Squad.all.pluck(:keeper_id)
        pl_list.each do|player_id|
            player = Player.find(player_id)
            player.keeper = true
            player.save
        end
        puts "Player Updated keeper"
    end

    def self.add_new_players
        file = File.read(PLAYERS_JSON_PATH)
        data = JSON.parse(file)
        latest_pid = 0
        if Player.last.present?
            latest_pid = Player.last.id
        end
        data.each do |player|
            p_id = player["id"]
            if p_id > latest_pid
                p = Player.new
                p.id = p_id
                p.fullname = player["fullname"]
                p.name = player["name"]
                p.country_team_id = player["country"]
                p.skill = player["skillset"][0]
                p.batting_hand = player["skillset"][1]
                p.bowling_hand = player["skillset"][2]
                p.bowling_style = player["skillset"][3]
                p.keeper = player["keeper"]
                trophies = PLAYER_TROPHIES_INIT
                p.trophies = trophies
                p.csl_team_id = player["csl"]
                p.ipl_team_id = player["ipl"]
                p.born_team_id = player["born"]
                unless p.save
                    puts "Player add error ❌"
                end
            end
        end
        puts "New players added"
    end

    def self.add_matches
        CSV.foreach(SEED_CSV_PATH + '/matches.csv', headers: true) do |row|
            m = Match.new
            m.id = row['id']
            m.stage = row['stage']
            m.venue = row['venue']
            if row['win_by_wickets']=='0'
                m.win_by_wickets = nil
            else
                m.win_by_wickets = row['win_by_wickets']
            end
            if row['win_by_runs']=='0'
                m.win_by_runs = nil
            else
                m.win_by_runs = row['win_by_runs']
            end
            m.ball_color1 = row['ball_color'][0]
            m.ball_color2 = row['ball_color'][1]
            m.dots = row['dots']
            m.c1 = row['c1']
            m.c2 = row['c2']
            m.c3 = row['c3']
            m.c4 = row['c4']
            m.c6 = row['c6']
            m.no_balls = row['noballs']
            m.wides = row['wides']
            m.extras = row['extras']
            m.tournament_id = row['tournament_id']
            m.inn1_id = row['inn1_id']
            m.inn2_id = row['inn2_id']
            winner_id = Squad.find_by(team_id: row['winners_team_id'], tournament_id: row['tournament_id']).id
            loser_id = Squad.find_by(team_id: row['losers_team_id'], tournament_id: row['tournament_id']).id
            m.winner_id = winner_id
            m.loser_id = loser_id
            m.motm_id = row['motm_id']
            m.wickets = row['wickets']
            m.save
        end
        puts "Matches added"
    end

    def self.update_matches
        CSV.foreach(SEED_CSV_PATH + '/matches.csv', headers: true) do |row|
            m = Match.find(row['id'])
            m.runs = row['runs']
            unless m.save
                puts "❌ seed#update_matches: error while updating match"
            end
        end
        puts "Matches Updated"
    end

    def self.add_innings
        CSV.foreach(SEED_CSV_PATH + '/innings.csv', headers: true) do |row|
            i = Inning.new
            i.id = row['id']
            i.bat_team_id = Squad.find_by(team_id: row['bat_team_id'], tournament_id: row['t_id']).id
            i.bow_team_id = Squad.find_by(team_id: row['bow_team_id'], tournament_id: row['t_id']).id
            i.inn_no = row['inn_no']
            i.score = row['score']
            i.for = row['for']
            i.overs = row['overs'].to_f
            i.match_id = row['m_id']
            i.tournament_id = row['t_id']
            i.dots = row['dots']
            i.c1 = row['c1']
            i.c2 = row['c2']
            i.c3 = row['c3']
            i.c4 = row['c4']
            i.c6 = row['c6']
            i.no_balls = row['noballs']
            i.wides = row['wides']
            i.extras = row['extras']
            i.ball_color1 = row['ball_color'][0]
            i.ball_color2 = row['ball_color'][1]
            i.save
        end
        puts "Innings added"
    end

    def self.add_overs
        CSV.foreach(SEED_CSV_PATH + '/overs.csv', headers: true) do |row|
            o = Over.new
            o.id = row['id']
            o.over_no = row['over_no']
            o.balls = row['balls']
            o.runs = row['runs']
            o.bow_runs = row['runs']
            o.wickets = row['wickets']
            o.wides = row['wides']
            o.no_balls = row['noballs']
            o.score = row['score']
            o.for = row['for']
            o.ball_color = row['ball_color']
            o.dots = row['dots']
            o.c1 = row['c1']
            o.c2 = row['c2']
            o.c3 = row['c3']
            o.c4 = row['c4']
            o.c6 = row['c6']
            o.bowler_id = row['bowler']
            o.tournament_id = row['t_id']
            o.match_id = row['m_id']
            o.inning_id = row['inn_id']
            o.save
        end
        puts "Overs added"
    end

    def self.add_balls
        CSV.foreach(SEED_CSV_PATH + '/balls.csv', headers: true) do |row|
            b = Ball.new
            b.id = row['id']
            runs = row['runs']
            extras = row['extras']
            bow_runs = 0
            wicket_ball = false
            if row['extra_type'] == 'w'
                runs = 0
                extras = row['extras']
                bow_runs = extras
                extra_type = "wd"
            elsif row['extra_type'] == 'n'
                runs = row['runs'].to_i - 1
                extras = 1
                bow_runs = extras + runs
                extra_type = "nb"
            elsif row['extra_type'] == 'b'
                runs = 0
                extra_type = "b"
            elsif row['extra_type'] == 'l'
                runs = 0
                extra_type = "lb"
            elsif row['extra_type'] == '0'
                bow_runs = runs
                extra_type = nil
            end
            if row['wicket_ball'] == '1'
                wicket_ball = true
            end
            b.runs = runs
            b.extras = extras
            b.bow_runs = bow_runs
            b.extra_type = extra_type
            b.delivery = row['delivery']
            b.wicket_ball = wicket_ball
            b.score = row['score']
            b.for = row['for']
            if row['dots']=='1'
                category = 'c0'
            elsif row['c1']=='1'
                category = 'c1'
            elsif row['c2']=='1'
                category = 'c2'
            elsif row['c3']=='1'
                category = 'c3'
            elsif row['c4']=='1'
                category = 'c4'
            elsif row['c6']=='1'
                category = 'c6'
            end
            b.category = category
            b.ball_color = row['ball_color']
            b.batsman_id = row['batsman']
            b.bowler_id = row['bowler']
            b.tournament_id = row['t_id']
            b.match_id = row['m_id']
            b.inning_id = row['inn_id']
            b.over_id = row['o_id']
            b.save
        end
        puts "Balls added"
    end

    def self.add_scores
        CSV.foreach(SEED_CSV_PATH + '/scores.csv', headers: true) do |row|
            s = Score.new
            s.match_id = row['m_id']
            s.id = (row['inn_id'].to_i - 1)*11 + row['pos'].to_i
            s.runs = row['runs']
            s.balls = row['balls']
            s.sr = row['sr']
            s.position = row['pos']
            s.batted = true
            if row['not_out']=='0'
                not_out = true
            else
                not_out = false
            end
            s.not_out = not_out
            s.dots = row['dots']
            s.c1 = row['c1']
            s.c2 = row['c2']
            s.c3 = row['c3']
            s.c4 = row['c4']
            s.c6 = row['c6']
            s.player_id = row['batsman']
            s.tournament_id = row['t_id']
            s.match_id = row['m_id']
            s.inning_id = row['inn_id']
            s.squad_id = Squad.find_by(team_id: row['team_id'], tournament_id: row['t_id']).id
            s.save
        end
        puts "Scores added"
    end

    def self.add_spells
        CSV.foreach(SEED_CSV_PATH + '/spells.csv', headers: true) do |row|
            s = Spell.new
            s.match_id = row['m_id']
            s.overs = row['overs']
            s.maidens = row['maidens']
            s.runs = row['runs']
            s.wickets = row['wickets']
            s.economy = row['er']
            if row['avg'].to_f > 0
                s.avg = row['avg']
            end
            if row['sr'].to_f > 0
                s.sr = row['sr']
            end
            s.wides = row['wides']
            s.no_balls = row['noballs']
            s.dots = row['dots']
            s.c1 = row['c1']
            s.c2 = row['c2']
            s.c3 = row['c3']
            s.c4 = row['c4']
            s.c6 = row['c6']
            s.player_id = row['bowler']
            s.tournament_id = row['t_id']
            s.match_id = row['m_id']
            s.inning_id = row['inn_id']
            s.squad_id = Squad.find_by(team_id: row['team_id'], tournament_id: row['t_id']).id
            s.save
        end
        puts "Spells added"
    end

    def self.add_wickets
        CSV.foreach(SEED_CSV_PATH + '/wickets.csv', headers: true) do |row|
            w = Wicket.new
            w.id = row['id']
            w.method = row['method']
            if w.method == 'c' or w.method == 'st'
                w.fielder_id = row['fielder']
            end
            w.ball_id = row['b_id']
            w.over_id = row['o_id']
            w.tournament_id = row['t_id']
            w.match_id = row['m_id']
            w.inning_id = row['inn_id']
            w.batsman_id = row['batsman']
            w.bowler_id = row['bowler']
            w.delivery = Ball.find(row['b_id']).delivery
            w.save
        end
        puts "Wickets added"
    end

    # def self.add_bat_stats
    #     CSV.foreach(SEED_CSV_PATH + '/bat_stats.csv', headers: true) do |row|
    #         b = BatStat.new
    #         b.id = row['p_id']
    #         b.player_id = row['p_id']
    #         b.innings = row['innings']
    #         b.runs = row['runs']
    #         b.balls = row['balls']
    #         b.sr = row['sr']
    #         b.avg = row['avg']
    #         b.not_outs = row['not_outs']
    #         b.dots = row['dots']
    #         b.c1 = row['c1']
    #         b.c2 = row['c2']
    #         b.c3 = row['c3']
    #         b.c4 = row['c4']
    #         b.c6 = row['c6']
    #         b.thirties = row['c30']
    #         b.fifties = row['c50']
    #         b.hundreds = row['c100']
    #         if row['balls']!='0'
    #             b.boundary_p = (((row['c4'].to_f+row['c6'].to_f)/row['balls'].to_f)*100).round(2)
    #             b.dot_p = ((row['dots'].to_f/row['balls'].to_f)*100).round(2)
    #         end
    #         b.best_id = row['best']
    #         b.save
    #     end
    #     puts "BatStats added"
    # end

    # def self.add_new_players_batstats
    #     latest_batstats_pid = BatStat.last.player_id
    #     latest_pid = Player.last.id
    #     while latest_batstats_pid <= latest_pid
    #         latest_batstats_pid += 1
    #         b = BatStat.new
    #         b.id = latest_batstats_pid
    #         b.player_id = latest_batstats_pid
    #         b.innings = 0
    #         b.runs = 0
    #         b.balls = 0
    #         b.sr = 0
    #         b.avg = 0
    #         b.not_outs = 0
    #         b.dots = 0
    #         b.c1 = 0
    #         b.c2 = 0
    #         b.c3 = 0
    #         b.c4 = 0
    #         b.c6 = 0
    #         b.thirties = 0
    #         b.fifties = 0
    #         b.hundreds = 0
    #         unless b.save
    #             puts "Batstat for new players failed ❌"
    #         end
    #     end
    #     puts "BatStats for new players added"
    # end

    # def self.add_ball_stats
    #     CSV.foreach(SEED_CSV_PATH + '/ball_stats.csv', headers: true) do |row|
    #         b = BallStat.new
    #         b.id = row['p_id']
    #         b.player_id = row['p_id']
    #         b.overs = row['overs']
    #         b.innings = row['innings']
    #         b.maidens = row['maidens']
    #         b.runs = row['runs']
    #         b.economy = row['economy']
    #         b.wickets = row['wickets']
    #         b.sr = row['sr']
    #         b.avg = row['avg']
    #         b.wides = row['wides']
    #         b.no_balls = row['noballs']
    #         b.dots = row['dots']
    #         b.c1 = row['c1']
    #         b.c2 = row['c2']
    #         b.c3 = row['c3']
    #         b.c4 = row['c4']
    #         b.c6 = row['c6']
    #         b.three_wickets = row['three_wickets']
    #         b.five_wickets = row['five_wickets']
    #         if row['overs']!='0'
    #             b.boundary_p = (((row['c4'].to_f+row['c6'].to_f)/Util.overs_to_balls(row['overs'].to_f))*100).round(2)
    #             b.dot_p = ((row['dots'].to_f/Util.overs_to_balls(row['overs'].to_f))*100).round(2)
    #         end
    #         b.best_id = row['best']
    #         b.save
    #     end
    #     puts "BallStats added"
    # end
    #
    # def self.add_new_players_ballstats
    #     latest_ballstats_pid = BallStat.last.player_id
    #     latest_pid = Player.last.id
    #     while latest_ballstats_pid <= latest_pid
    #         latest_ballstats_pid += 1
    #         b = BallStat.new
    #         b.id = latest_ballstats_pid
    #         b.player_id = latest_ballstats_pid
    #         b.overs = 0
    #         b.innings = 0
    #         b.maidens = 0
    #         b.runs = 0
    #         b.economy = 0
    #         b.wickets = 0
    #         b.sr = 0
    #         b.avg = 0
    #         b.wides = 0
    #         b.no_balls = 0
    #         b.dots = 0
    #         b.c1 = 0
    #         b.c2 = 0
    #         b.c3 = 0
    #         b.c4 = 0
    #         b.c6 = 0
    #         b.three_wickets = 0
    #         b.five_wickets = 0
    #         unless b.save
    #             puts "Ballstat for new players failed ❌"
    #         end
    #     end
    #     puts "BallStats for new players added"
    # end

    def self.update_overs
        overs = Over.all
        overs.each do |over|
            extras = 0
            bow_runs = 0
            balls = Ball.where(over_id: over.id)
            balls.each do |ball|
                extras += ball.extras
                if ball.extra_type!='lb' and ball.extra_type!='b'
                    bow_runs += ball.extras + ball.runs
                end
            end
            over.bow_runs = bow_runs
            over.extras = extras
            unless over.save
                puts "Over update failed ❌"
            end
        end
        puts "Overs updated"
    end

    def self.add_partnerships
        CSV.foreach(SEED_CSV_PATH + '/partnerships.csv', headers: true) do |row|
            p = Partnership.new
            p.id = row['id']
            p.runs = row['runs']
            p.balls = row['balls']
            p.c1 = row['c1']
            p.c2 = row['c2']
            p.c3 = row['c3']
            p.c4 = row['c4']
            p.c6 = row['c6']
            p.dots = row['dots']
            p.sr = row['sr']
            p.for_wicket = row['for_wicket']
            if row['unbeaten']=='0'
                not_out = true
            else
                not_out = false
            end
            p.not_out = not_out
            p.b1s = row['b1s']
            p.b2s = row['b2s']
            p.b1b = row['b1b']
            p.b2b = row['b2b']
            p.tournament_id = row['t_id']
            p.match_id = row['m_id']
            p.inning_id = row['inn_id']
            p.batsman1_id = row['b1']
            p.batsman2_id = row['b2']
            p.bat_team_id = row['bat_team']
            p.bow_team_id = row['bow_team']
            p.save
        end
        puts "Partnerships added"
    end

    def self.add_performances
        CSV.foreach(SEED_CSV_PATH + '/performances.csv', headers: true) do |row|
            p = Performance.new
            p.won = row['won']
            if row['captain']=='1'
                p.captain = true
            else
                p.captain = false
            end

            p.tournament_id = Match.find(row['m_id']).tournament_id
            p.match_id = row['m_id']
            p.player_id = row['p_id']
            p.id = Score.where(match_id: p.match_id, player_id: p.player_id).first.id
            p.squad_id = Squad.find_by(tournament_id: p.tournament_id, team_id: row['team_id']).id
            if p.player_id == p.squad.keeper.id
                keeper = true
            else
                keeper = false
            end
            p.keeper = keeper
            p.save
        end
        puts "Performances added"
    end

    def self.add_playing_11_scores
        file = File.read(SEED_JSON_PATH + '/dnb_total.json')
        data = JSON.parse(file)
        m_id = 1
        while m_id <= 151
            temp = data["#{m_id}"]
            inn1 = temp[0]
            inn2 = temp[1]
            score = Score.where(inning_id: (2*m_id)-1).last
            score_id = score.id
            inn1.each do|p_id|
                score_id += 1
                s = Score.new
                s.id = score_id
                s.player_id = p_id
                s.batted = false
                s.squad_id = score.squad_id
                s.inning_id = score.inning_id
                s.match_id = score.match_id
                s.tournament_id = score.tournament_id
                unless s.save
                    puts s.errors
                    puts "could not save #{p_id}, #{m_id} ❌"
                end
            end

            score = Score.where(inning_id: 2*m_id).last
            score_id = score.id
            inn2.each do|p_id|
                score_id += 1
                s = Score.new
                s.id = score_id
                s.player_id = p_id
                s.batted = false
                s.squad_id = score.squad_id
                s.inning_id = score.inning_id
                s.match_id = score.match_id
                s.tournament_id = score.tournament_id
                unless s.save
                    puts s.errors
                    puts "could not save #{p_id}, #{m_id} ❌"
                end
            end
            m_id += 1
        end
    end

    def self.add_playing_11_performances
        scores = Score.all
        scores.each do|score|
            p_id = score.player_id
            m_id = score.match_id
            perf = Performance.where(match_id: m_id, player_id: p_id)
            if perf.length == 0
                p = Performance.new
                p.player_id = p_id
                p.match_id = m_id
                p.squad_id = score.squad_id
                p.id = score.id
                p.captain = false
                p.keeper = false
                p.tournament_id = score.tournament_id
                if Match.find(m_id).winner_id == p.squad_id
                    p.won = true
                else
                    p.won = false
                end
                unless p.save
                    puts "could not save add_playing_11_performances for #{p_id} for #{m_id} ❌"
                end

            end

        end
        puts "Playing 11 Performances added"
    end

    def self.preload_squad_players
        file = File.read(SQUADS_JSON_PATH)
        data = JSON.parse(file)
        data.each do|tour|
            t_id = tour['t_id']
            squads = tour['squads']
            squads.each do|squad|
                team_id = squad['team_id']
                squad_id = squad['squad_id']
                players = squad['players']
                players.each do|p_id|
                    s = SquadPlayer.new
                    s.player_id = p_id
                    s.squad_id = squad_id
                    s.team_id = team_id
                    s.tournament_id = t_id
                    unless s.save
                        puts "Squad Player error ❌"
                    end
                end

            end
        end
        puts "Squad players preloaded"
    end

    def self.preload_schedules
        file = File.read(SCHEDULE_JSON_PATH)
        data = JSON.parse(file)
        data.each do|tour|
            t_id = tour['t_id']
            matches = tour['matches']
            matches.each do|match|
                s = Schedule.new
                s.id = match['m_id']
                s.squad1_id = Squad.find_by(tournament_id: t_id, team_id: Team.find_by(abbrevation: match['squad1']))&.id
                s.squad2_id = Squad.find_by(tournament_id: t_id, team_id: Team.find_by(abbrevation: match['squad2']))&.id
                s.venue = match['venue']
                s.stage = match['stage']
                s.tournament_id = t_id
                s.completed = Match.where(id: match['m_id']).present? ? true : false
                unless s.save
                    puts "❌ ERROR in preload schedules in match #{m_id}"
                end
            end
        end
        puts "Schedules preloaded"
    end

    def self.clear_schedule_entries
        Schedule.delete_all
        puts "Schedules Cleared from db"
    end

    def self.add_new_squads
        file = File.read(SQUADS_JSON_PATH)
        data = JSON.parse(file)
        data.each do|tour|
            t_id = tour['t_id']
            squads = tour['squads']
            squads.each do|squad|
                team_id = squad['team_id']
                squad_id = squad['squad_id']
                x = Squad.where(team_id: team_id, tournament_id: t_id)
                if x==[]
                    s = Squad.new
                    s.id = squad_id
                    s.name = squad['name']
                    s.abbrevation = squad['abbrevation']
                    s.matches = 0
                    s.won = 0
                    s.lost = 0
                    s.runs = 0
                    s.wickets = 0
                    s.runs_conceded = 0
                    s.wickets_lost = 0
                    s.tournament_id = t_id
                    s.team_id = team_id
                    s.captain_id = squad['captain_id']
                    s.keeper_id = squad['keeper_id']
                    s.nrr = 0
                    unless s.save
                        puts "❌ New squad could not be added. #{squad_id}"
                    end
                end
            end
        end
    end

    def self.update_squad_players
        SquadPlayer.delete_all
        Seed.preload_squad_players
    end

    def self.add_existing_matches
        New.add_existing_matches_to_db
    end
end
