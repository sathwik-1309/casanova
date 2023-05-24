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
      temp = temp.sort_by { |team| [-team["points"], -team["nrr"]] }
      pos = 0
      temp.each do |team|
        pos += 1
        team["pos"] = pos
      end

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
    bat_stats_hash = Helper.construct_bat_stats_hash(Score.where(tournament_id: t_id, batted: true))
    bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["runs"], batsman["innings"]] }
    bat_stats["boxes"] << {
      "header"=> "Highest Scorers",
      "data"=> Helper.format_individual_stats(bat_stats_hash[0..4], "runs", "innings", t_id)}

    bat_stats_hash_sr = bat_stats_hash.select { |batsman| batsman["runs"] > 80}
    bat_stats_hash_sr = bat_stats_hash_sr.sort_by { |batsman| [-batsman["sr"], -batsman["runs"]] }
    bat_stats["boxes"] << {
      "header"=> "Highest Strike-rates",
      "data"=>Helper.format_individual_stats(bat_stats_hash_sr[0..4], "sr", "runs", t_id)}

    bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["sixes"], -batsman["sr"]] }
    bat_stats["boxes"] << {
      "header"=> "Most Sixes",
      "data"=>Helper.format_individual_stats(bat_stats_hash[0..4], "sixes", "innings", t_id)}

    bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["fours"], -batsman["sr"]] }
    bat_stats["boxes"] << {
      "header"=> "Most Fours",
      "data"=>Helper.format_individual_stats(bat_stats_hash[0..4], "fours", "innings", t_id)}

    bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["fifties"], -batsman["runs"]] }
    bat_stats["boxes"] << {
      "header"=> "Most Fifties",
      "data"=>Helper.format_individual_stats(bat_stats_hash[0..4], "fifties", "innings", t_id)}

    bat_stats_hash_avg = bat_stats_hash.select { |batsman| batsman["avg"]}
    bat_stats_hash_avg = bat_stats_hash_avg.sort_by { |batsman| [-batsman["avg"], -batsman["runs"]] }
    bat_stats["boxes"] << {
      "header"=> "Highest Average",
      "data"=>Helper.format_individual_stats(bat_stats_hash_avg[0..4], "avg", "runs", t_id)}

    bat_stats_hash_dp = bat_stats_hash.select { |batsman| batsman["runs"] > 50}
    bat_stats_hash_dp = bat_stats_hash_dp.sort_by { |batsman| [batsman["dot_p"], -batsman["runs"]] }
    bat_stats["boxes"] << {
      "header"=> "Lowest Dot-ball %",
      "data"=>Helper.format_individual_stats(bat_stats_hash_dp[0..4], "dot_p", "runs", t_id)}

    bat_stats_hash_bp = bat_stats_hash.select { |batsman| batsman["runs"] > 80}
    bat_stats_hash_bp = bat_stats_hash_bp.sort_by { |batsman| [-batsman["boundary_p"], -batsman["runs"]] }
    bat_stats["boxes"] << {
      "header"=> "Highest Boundary %",
      "data"=>Helper.format_individual_stats(bat_stats_hash_bp[0..4], "boundary_p", "runs", t_id)}

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

    ball_stats_hash = ball_stats_hash.sort_by { |bowler| [-bowler["3w"], -bowler["wickets"]] }
    ball_stats["boxes"] << {
      "header"=> "Most 3-w hauls",
      "data"=>Helper.format_individual_stats(ball_stats_hash[0..4], "3w", "wickets", t_id)}

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
end
