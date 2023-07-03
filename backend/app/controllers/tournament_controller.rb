class TournamentController < ApplicationController
  def points_table
    t_id = params[:t_id]
    hash = {}

    tour = Util.get_tournament_json(t_id.to_i)
    groups = tour["groups"]
    points_table = []
    journey = {}
    groups.each do |group|
      temp = []
      group.each do |team_id|
        pt = {}
        squad = Squad.find_by(team_id: team_id, tournament_id: t_id.to_i)
        print [team_id, t_id]
        pt["team"] = "#{Util.get_flag(team_id)} #{squad.abbrevation.upcase}"
        pt["color"] = squad.abbrevation
        pt["won"] = Match.where(stage: ['league','group'],winner_id: squad.id).length
        pt["lost"] = Match.where(stage: ['league','group'],loser_id: squad.id).length
        pt["played"] = pt["won"] + pt["lost"]
        pt["points"] = (pt["won"] * 2 )
        pt["nrr"] = Util.format_nrr(squad.nrr)
        pt["team_id"] = team_id
        matches = Match.where(id: Inning.where(bat_team_id: squad.id).pluck(:match_id))
        journey_team = []
        matches.each do |match|
          match_hash = {}
          match_hash["result"] = match.get_journey_result(squad)
          match_hash["won"] = match.winner_id == squad.id ? true : false
          match_hash["vs_team"] = match_hash["won"] ? Squad.find(match.loser_id).get_abb : Squad.find(match.winner_id).get_abb
          journey_team << match_hash
        end
        journey["#{team_id}"] = {
          "teamname" => "#{Util.get_flag(team_id)} #{squad.abbrevation.upcase}",
          "color" => squad.abbrevation,
          "journey" => journey_team}
        temp << pt
      end
      temp.each do |team|
        if team["nrr"][0] == '-'
          team["nrr_float"] = -1 * (team["nrr"][2..].to_f)
        else
          team["nrr_float"] = team["nrr"][2..].to_f
        end
      end
      temp = temp.sort_by { |team| [-team["points"], -team["nrr_float"]] }
      print temp
      pos = 0
      temp.each do |team|
        pos += 1
        team["pos"] = pos
      end
      print temp

      points_table << temp
    end

    hash["tour"] = "#{Tournament.find(t_id.to_i).name}_#{t_id}"
    hash["points_table"] = points_table
    hash["journeys"] = journey
    render(:json => Oj.dump(hash))
  end

  def bat_stats
    t_id = params[:t_id]
    hash = {}

    bat_stats = {}
    bat_stats["boxes"] = []
    stats = BatStat.where(sub_type: "tour_#{t_id}")
    selected = stats.sort_by { |stat| -stat.runs }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Highest Scorers",
      "data"=> Helper.bat_stats_to_hash(selected, 'runs', t_id)}

    stats2 = stats.select { |stat| stat.sr and stat.runs > 80 }
    selected = stats2.sort_by { |stat| -stat.sr }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Highest Strike-rates",
      "data"=> Helper.bat_stats_to_hash(selected, 'sr', t_id)}

    selected = stats.sort_by { |stat| -stat.c6 }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Most Sixes",
      "data"=> Helper.bat_stats_to_hash(selected, 'c6', t_id)}

    selected = stats.sort_by { |stat| -stat.c4 }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Most Fours",
      "data"=> Helper.bat_stats_to_hash(selected, 'c4', t_id)}

    selected = stats.sort_by { |stat| -stat.fifties }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Most Fifties",
      "data"=> Helper.bat_stats_to_hash(selected, 'fifties', t_id)}

    stats2 = stats.select { |stat| stat.avg and stat.runs > 80 }
    selected = stats2.sort_by { |stat| -stat.avg }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Highest Average",
      "data"=> Helper.bat_stats_to_hash(selected, 'avg', t_id)}

    stats2 = stats.select { |stat| stat.runs > 80 }
    selected = stats2.sort_by { |stat| stat.dot_p }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Lowest Dot %",
      "data"=> Helper.bat_stats_to_hash(selected, 'dot_p', t_id)}

    stats2 = stats.select { |stat| stat.runs > 80 }
    selected = stats2.sort_by { |stat| -stat.boundary_p }[0..4]
    bat_stats["boxes"] << {
      "header"=> "Highest Boundary %",
      "data"=> Helper.bat_stats_to_hash(selected, 'boundary_p', t_id)}

    # bat_stats_hash = Helper.construct_bat_stats_hash(Score.where(tournament_id: t_id, batted: true))
    # bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["runs"], batsman["innings"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Highest Scorers",
    #   "data"=> Helper.format_individual_stats(bat_stats_hash[0..4], "runs", "innings", t_id)}
    #
    # bat_stats_hash_sr = bat_stats_hash.select { |batsman| batsman["runs"] > 80}
    # bat_stats_hash_sr = bat_stats_hash_sr.sort_by { |batsman| [-batsman["sr"], -batsman["runs"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Highest Strike-rates",
    #   "data"=>Helper.format_individual_stats(bat_stats_hash_sr[0..4], "sr", "runs", t_id)}
    #
    # bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["sixes"], -batsman["sr"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Most Sixes",
    #   "data"=>Helper.format_individual_stats(bat_stats_hash[0..4], "sixes", "innings", t_id)}
    #
    # bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["fours"], -batsman["sr"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Most Fours",
    #   "data"=>Helper.format_individual_stats(bat_stats_hash[0..4], "fours", "innings", t_id)}
    #
    # bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["fifties"], -batsman["runs"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Most Fifties",
    #   "data"=>Helper.format_individual_stats(bat_stats_hash[0..4], "fifties", "innings", t_id)}
    #
    # bat_stats_hash_avg = bat_stats_hash.select { |batsman| batsman["avg"]}
    # bat_stats_hash_avg = bat_stats_hash_avg.sort_by { |batsman| [-batsman["avg"], -batsman["runs"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Highest Average",
    #   "data"=>Helper.format_individual_stats(bat_stats_hash_avg[0..4], "avg", "runs", t_id)}
    #
    # bat_stats_hash_dp = bat_stats_hash.select { |batsman| batsman["runs"] > 50}
    # bat_stats_hash_dp = bat_stats_hash_dp.sort_by { |batsman| [batsman["dot_p"], -batsman["runs"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Lowest Dot-ball %",
    #   "data"=>Helper.format_individual_stats(bat_stats_hash_dp[0..4], "dot_p", "runs", t_id)}
    #
    # bat_stats_hash_bp = bat_stats_hash.select { |batsman| batsman["runs"] > 80}
    # bat_stats_hash_bp = bat_stats_hash_bp.sort_by { |batsman| [-batsman["boundary_p"], -batsman["runs"]] }
    # bat_stats["boxes"] << {
    #   "header"=> "Highest Boundary %",
    #   "data"=>Helper.format_individual_stats(bat_stats_hash_bp[0..4], "boundary_p", "runs", t_id)}

    hash["tour"] = Tournament.find(t_id).get_tour_font
    hash["bat_stats"] = bat_stats
    render(:json => Oj.dump(hash))
  end

  def ball_stats
    t_id = params[:t_id]
    hash = {}

    ball_stats = {}
    ball_stats["boxes"] = []
    ball_stats_hash = Helper.construct_ball_stats_hash(Spell.where(tournament_id: t_id))

    ball_stats_hash = ball_stats_hash.sort_by { |bowler| [-bowler["wickets"], bowler["eco"]] }
    ball_stats["boxes"] << {
      "header"=> "Highest Wicket-takers",
      "data"=> Helper.format_individual_stats(ball_stats_hash[0..4], "wickets", "innings", t_id)}

    ball_stats_hash_eco = ball_stats_hash.select { |bowler| bowler["balls"] > 48 }
    ball_stats_hash_eco = ball_stats_hash_eco.sort_by { |bowler| [bowler["eco"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Best Economy",
      "data"=> Helper.format_individual_stats(ball_stats_hash_eco[0..4], "eco", "wickets", t_id)}

    ball_stats_hash_sr = ball_stats_hash.select { |bowler| bowler["wickets"] > 5 }
    ball_stats_hash_sr = ball_stats_hash_sr.sort_by { |bowler| [bowler["sr"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Best Bowling SR",
      "data"=>Helper.format_individual_stats(ball_stats_hash_sr[0..4], "sr", "wickets", t_id)}

    ball_stats_hash_avg = ball_stats_hash.select { |bowler| bowler["wickets"] > 5 }
    ball_stats_hash_avg = ball_stats_hash_avg.sort_by { |bowler| [bowler["avg"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Best Bowling Avg",
      "data"=>Helper.format_individual_stats(ball_stats_hash_avg[0..4], "avg", "wickets", t_id)}

    ball_stats_hash = ball_stats_hash.sort_by { |bowler| [-bowler["_3w"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Most 3-w hauls",
      "data"=>Helper.format_individual_stats(ball_stats_hash[0..4], "_3w", "wickets", t_id)}

    ball_stats_hash = ball_stats_hash.sort_by { |bowler| [-bowler["maidens"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Most Maidens",
      "data"=> Helper.format_individual_stats(ball_stats_hash[0..4], "maidens", "wickets", t_id)}

    ball_stats_hash_dp = ball_stats_hash.select { |bowler| bowler["balls"] > 48}
    ball_stats_hash_dp = ball_stats_hash_dp.sort_by { |bowler| [-bowler["dot_p"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Highest Dot %",
      "data"=> Helper.format_individual_stats(ball_stats_hash_dp[0..4], "dot_p", "eco", t_id)}

    ball_stats_hash_bp = ball_stats_hash.select { |bowler| bowler["balls"] > 48}
    ball_stats_hash_bp = ball_stats_hash_bp.sort_by { |bowler| [bowler["boundary_p"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Lowest Boundary %",
      "data"=> Helper.format_individual_stats(ball_stats_hash_bp[0..4], "boundary_p", "eco", t_id)}

    hash["tour"] = Tournament.find(t_id).get_tour_font
    hash["ball_stats"] = ball_stats
    render(:json => Oj.dump(hash))
  end

  def home_page
    hash = {}
    hash["tournaments"] = []
    hash["tournaments"] << Helper.tournament_class_box("wt20")
    hash["tournaments"] << Helper.tournament_class_box("ipl")
    hash["tournaments"] << Helper.tournament_class_box("csl")
    render(:json => Oj.dump(hash))
  end

  def tournaments_home
    hash = {}
    hash["tournaments"] = []
    tours = Tournament.where(name: params[:tour_class])
    tours.each do|tour|
      hash["tournaments"] << tour.tournament_box
    end
    render(:json => Oj.dump(hash))
  end

  def tournament_home
    t_id = params[:t_id]
    hash = {}
    box1 = {}
    box2 = {}
    tour = Tournament.find(t_id)
    final = Match.find_by(tournament_id: t_id, stage: 'final')
    if final
      hash['ongoing'] = false
      winner = Squad.find(final.winner_id)
      runner = Squad.find(final.loser_id)
      box1["winners"] = {
        "teamname" => winner.get_teamname,
        "color" => winner.abbrevation
      }
      box1["runners"] = {
        "teamname" => runner.get_teamname,
        "color" => runner.abbrevation
      }
      box1["final"] = Match.match_box(final.id)
      gem = Player.find(final.motm_id)
      box1["gem"] = gem.tour_individual_awards_to_hash(t_id, "gem")
      box1["gem"]["data"] = gem.match_performance_string(final.id)

      pots = Player.find(tour.pots_id)
      box2["pots"] = pots.tour_individual_awards_to_hash(t_id, "pots")

      mvp = Player.find(tour.mvp_id)
      box2["mvp"] = mvp.tour_individual_awards_to_hash(t_id, "mvp")

      most_runs_player = Player.find(tour.most_runs_id)
      box2["most_runs"] = most_runs_player.tour_individual_awards_to_hash(t_id, "most_runs")

      most_wickets_player = Player.find(tour.most_wickets_id)
      box2["most_wickets"] = most_wickets_player.tour_individual_awards_to_hash(t_id, "most_wickets")

    else
      hash['ongoing'] = true
      upcoming_matches = []
      latest_mid = Match.last.id
      schedules = Schedule.where(tournament_id: t_id).where("id > #{latest_mid}").order(id: :asc).limit(3)
      tourname = Tournament.find(t_id).get_tour_with_season
      schedules.each do|schedule|
        temp = {}
        temp['tourname'] = tourname
        temp['venue'] = schedule.venue.upcase
        temp['team1'] = Helper.upcoming_match_team_to_hash(schedule.squad1)
        temp['team2'] = Helper.upcoming_match_team_to_hash(schedule.squad2)
        upcoming_matches << temp
      end
      box1['upcoming_matches'] = upcoming_matches
      points = tour.get_mvp_sorted_hash
      points = points.sort_by { |key, value| -value }
      mvp_pid = points[0][0]
      mvp = Player.find(mvp_pid)
      box2["mvp"] = mvp.tour_individual_awards_to_hash(t_id, "mvp", {"points" => points[0][1]})

      most_runs = BatStat.where(sub_type: "tour_#{t_id}").order(runs: :desc).limit(1).first
      most_runs_player = Player.find(most_runs.player_id)
      box2["most_runs"] = most_runs_player.tour_individual_awards_to_hash(t_id, "most_runs", {"runs" => most_runs.runs})

      most_wickets = BallStat.where(sub_type: "tour_#{t_id}").order(wickets: :desc).limit(1).first
      most_wickets_player = Player.find(most_wickets.player_id)
      box2["most_wickets"] = most_wickets_player.tour_individual_awards_to_hash(t_id, "most_wickets", {"wickets" => most_wickets.wickets})
    end

    tour_stats = {}
    matches = Match.where(tournament_id: t_id)
    tour_stats["matches"] = matches.count
    tour_stats["defended"] = matches.where('win_by_runs > 0').length
    tour_stats["chased"] = matches.where('win_by_wickets > 0').length
    inn1 = Inning.where(tournament_id: t_id, inn_no: 1)
    tour_stats["avg_score"] = (inn1.pluck(:score).sum.to_f/inn1.length).round(0)
    tour_stats["avg_wickets"] = (inn1.pluck(:for).sum.to_f/inn1.length).round(1)
    hash["box1"] = box1
    hash["box2"] = box2
    hash["tour_stats"] = tour_stats
    render(:json => Oj.dump(hash))
  end
end
