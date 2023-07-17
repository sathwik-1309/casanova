class PlayerController < ApplicationController
  def bat_stats
    p_id = params[:p_id]
    hash = {}
    player = Player.find(p_id)

    scores = Score.where(player_id: p_id)
    team = Team.find(player.country_team_id)
    hash["career"] = Helper.repeat2(scores, p_id, 1, player, team, 'wt20_1')


    scores = Score.where(player_id: p_id, tournament_id: WT20_IDS)
    if scores.length > 0
      team = Team.find(player.country_team_id)
      hash["int"] = Helper.repeat2(scores, p_id, 1, player, team, 'wt20_1')
    end


    scores = Score.where(player_id: p_id, tournament_id: IPL_IDS)
    if scores.length > 0
      team = Team.find(player.ipl_team_id)
      hash["ipl"] = Helper.repeat2(scores, p_id, 2, player, team, 'ipl_2')
    end

    scores = Score.where(player_id: p_id, tournament_id: CSL_IDS)
    if scores.length > 0
      team = Team.find(player.csl_team_id)
      hash["csl"] = Helper.repeat2(scores, p_id, 3, player, team, 'csl_3')
    end

    render(:json => Oj.dump(hash))
  end

  def ball_stats
    p_id = params[:p_id]
    hash = {}
    player = Player.find(p_id)

    spells = Spell.where(player_id: p_id)
    team = Team.find(player.country_team_id)
    matches = Score.where(player_id: p_id).count
    hash["career"] = Helper.repeat1(spells, p_id, 1, player, team, 'wt20_1', matches)

    spells = Spell.where(player_id: p_id, tournament_id: WT20_IDS)
    matches = Score.where(player_id: p_id, tournament_id: WT20_IDS).count
    if matches > 0
      team = Team.find(player.country_team_id)
      hash["int"] = Helper.repeat1(spells, p_id, 1, player, team, 'wt20_1', matches)
    end

    spells = Spell.where(player_id: p_id, tournament_id: IPL_IDS)
    matches = Score.where(player_id: p_id, tournament_id: IPL_IDS).count
    if matches > 0
      team = Team.find(player.ipl_team_id)
      hash["ipl"] = Helper.repeat1(spells, p_id, 2, player, team, 'ipl_2', matches)
    end

    spells = Spell.where(player_id: p_id, tournament_id: CSL_IDS)
    matches = Score.where(player_id: p_id, tournament_id: CSL_IDS).count
    if matches > 0
      team = Team.find(player.csl_team_id)
      hash["csl"] = Helper.repeat1(spells, p_id, 3, player, team, 'csl_3', matches)
    end
    render(:json => Oj.dump(hash))
  end

  def batting_meta
    bat_stats_hash = Helper.construct_bat_stats_hash(Score.where(batted: true))
    bat_stats_hash = bat_stats_hash.sort_by { |batsman| [-batsman["runs"], batsman["innings"]] }
    hash = {}
    selected = bat_stats_hash[0..19]
    count = 1
    selected.each do |batsman|
      player = Player.find(batsman["p_id"])
      batsman["name"] = player.fullname.upcase
      batsman["color"] = player.country.abbrevation
      batsman["pos"] = count
      batsman["dot_p"] = batsman["dot_p"].to_i
      batsman["boundary_p"] = batsman["boundary_p"].to_i
      count += 1
    end
    hash["meta"] = selected
    hash["font"] = "wt20_1"
    render(:json => Oj.dump(hash))
  end

  def bowling_meta
    ball_stats_hash = Helper.construct_ball_stats_hash(Spell.all)
    ball_stats_hash = ball_stats_hash.sort_by { |bowler| [-bowler["wickets"], bowler["eco"]] }
    hash = {}
    selected = ball_stats_hash[0..19]
    count = 1
    selected.each do |bowler|
      player = Player.find(bowler["p_id"])
      bowler["overs"] = Util.balls_to_overs(bowler["balls"])
      bowler["name"] = player.fullname.upcase
      bowler["color"] = player.country.abbrevation
      bowler["dot_p"] = bowler["dot_p"].to_i
      bowler["boundary_p"] = bowler["boundary_p"].to_i
      bowler["pos"] = count
      count += 1
    end
    hash["meta"] = selected
    hash["font"] = "wt20_1"
    render(:json => Oj.dump(hash))
  end

  def players
    array = []
    players = Player.all
    if params[:tour_class]
      case params[:tour_class]
      when 'wt20'
        tour_ids = WT20_IDS
      when 'ipl'
        tour_ids = IPL_IDS
      when 'csl'
        tour_ids = CSL_IDS
      end
      array = Helper.construct_players_hash_for_tour(tour_ids, players)
    elsif params[:t_id]
      tour_ids = params[:t_id]
      array = Helper.construct_players_hash_for_tour(tour_ids, players)
    else
      players.each do |player|
        hash = Helper.construct_player_details(player)
        hash["color"] = player.country.abbrevation || nil
        hash["teamname"] = player.country.get_teamname || nil
        array << hash
      end
    end
    array = Helper.group_by_team(array, "color")
    render(:json => Oj.dump(array))
  end

  def search
    pattern = params[:pattern]

    players = Player.where("fullname LIKE ?", "%#{pattern}%")
    result = players.map { |player| { id: player.id, name: player.fullname.titleize } }[..9]

    render json: result
  end
end
