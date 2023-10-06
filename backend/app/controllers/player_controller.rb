class PlayerController < ApplicationController

  def create
    attributes = filter_params
    attributes[:fullname] = attributes[:fullname].downcase
    attributes[:name] = attributes[:name].downcase
    attributes[:bowling_hand], attributes[:bowling_style] = convert_to_nil(attributes[:bowling_hand], attributes[:bowling_style])
    attributes[:csl_team_id], attributes[:ipl_team_id] = convert_to_nil(attributes[:csl_team_id], attributes[:ipl_team_id])
    attributes[:trophies] = PLAYER_TROPHIES_INIT
    player = Player.new(attributes)
    begin
      player.validate
      player.save!
      msg = player.attributes
      render_200("Player created", msg)
    rescue StandardError => ex
      render_202(ex.message)
    end
  end
  def bat_stats
    p_id = params[:p_id]
    hash = {}
    player = Player.find(p_id)

    scores = Score.where(player_id: p_id)
    team = Team.find(player.country_team_id)
    hash["career"] = Helper.repeat2(scores, p_id, 1, player, team, 'wt20_1')


    scores = Score.where(player_id: p_id, tournament_id: Tournament.wt20_ids)
    if scores.length > 0
      team = Team.find(player.country_team_id)
      hash["int"] = Helper.repeat2(scores, p_id, 1, player, team, 'wt20_1')
    end


    scores = Score.where(player_id: p_id, tournament_id: Tournament.ipl_ids)
    if scores.length > 0
      team = Team.find(player.ipl_team_id)
      hash["ipl"] = Helper.repeat2(scores, p_id, 2, player, team, 'ipl_2')
    end

    scores = Score.where(player_id: p_id, tournament_id: Tournament.csl_ids)
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

    spells = Spell.where(player_id: p_id, tournament_id: Tournament.wt20_ids)
    matches = Score.where(player_id: p_id, tournament_id: Tournament.wt20_ids).count
    if matches > 0
      team = Team.find(player.country_team_id)
      hash["int"] = Helper.repeat1(spells, p_id, 1, player, team, 'wt20_1', matches)
    end

    spells = Spell.where(player_id: p_id, tournament_id: Tournament.ipl_ids)
    matches = Score.where(player_id: p_id, tournament_id: Tournament.ipl_ids).count
    if matches > 0
      team = Team.find(player.ipl_team_id)
      hash["ipl"] = Helper.repeat1(spells, p_id, 2, player, team, 'ipl_2', matches)
    end

    spells = Spell.where(player_id: p_id, tournament_id: Tournament.csl_ids)
    matches = Score.where(player_id: p_id, tournament_id: Tournament.csl_ids).count
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
    # array = []
    # players = Player.all
    # if params[:tour_class]
    #   tour_ids = Helper.get_tour_class_ids2(params[:tour_class])
    #   array = Helper.construct_players_hash_for_tour(tour_ids, players)
    # elsif params[:t_id]
    #   tour_ids = params[:t_id]
    #   array = Helper.construct_players_hash_for_tour(tour_ids, players)
    # else
    #   players.each do |player|
    #     hash = Helper.construct_player_details(player)
    #     hash["color"] = player.country.abbrevation || nil
    #     hash["teamname"] = player.country.get_teamname || nil
    #     array << hash
    #   end
    # end
    array = []
    players = Player.all
    if params[:tour_class]
      tour_ids = Helper.get_tour_class_ids2(params[:tour_class])
      sp = SquadPlayer.where(tournament_id: tour_ids)
      sp.each do |s|
        hash = s.player.attributes.slice('p_id', 'batting_hand', 'bowling_hand', 'bowling_style')
        hash["p_id"] = s.player.id
        hash["name"] = s.player.fullname.length > 13 ? s.player.name.titleize : s.player.fullname.titleize
        hash["color"] = s.squad.abbrevation || nil
        hash["teamname"] = s.squad.get_teamname || nil
        hash["skill"] = s.player.keeper ? 'WK' : s.player.skill.upcase
        array << hash
      end
    elsif params[:t_id]
      tour_ids = params[:t_id]
      array = Helper.construct_players_hash_for_tour(tour_ids, players)
    elsif params[:team_id]
      team = Team.find_by_id(params[:team_id])
      squad_ids = team.squads.pluck(:id)
      players = Player.where(id: SquadPlayer.where(squad_id: squad_ids).map{|s| s.player_id}.uniq)
      players.each do |player|
        temp = Helper.construct_player_details(player)
        temp["color"] = team.abbrevation
        temp["teamname"] = team.get_teamname
        array << temp
      end
    elsif params[:squad_id]
      squad = Squad.find_by_id(params[:squad_id])
      players = SquadPlayer.where(squad_id: squad.id).map{|s| s.player }
      players.each do |player|
        temp = Helper.construct_player_details(player)
        temp["color"] = squad.abbrevation
        temp["teamname"] = squad.get_teamname
        array << temp
      end
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
    players = players[..9]
    result = []
    players.each do |player|
      result << hash = Helper.construct_player_details(player)
    end

    render json: result
  end

  def home_page
    player = Player.find(params[:p_id])
    hash = {}
    hash['profile'] = player.profile_hash
    hash['trophy_cabinet'] = player.trophy_cabinet_hash
    hash['stat_options'] = player.get_stat_options
    render(:json => Oj.dump(hash))
  end

  # add support for venue and vs_team
  def bat_stats2
    p_id = params[:p_id]
    hash = {}
    type, value = Player.get_stat_type(params)
    sub_type = Player.get_stat_sub_type(type, value)
    player = Player.find(p_id)
    hash['name'] = player.fullname.titleize
    hash['teamname'], hash['color'] = player.get_stat_teamname_and_color(type, value)
    hash['p_id'] = player.id
    if sub_type
      stat = BatStat.find_by(player_id: p_id, sub_type: sub_type)
      hash['bat_stats'] = {}
      # raise StandardError.new("PlayerController#bat_stats2: Stat not found for player #{p_id}, sub_type #{sub_type}") if stat.nil?
      hash['bat_stats'] = stat.get_hash unless stat.nil?
    else
      case type
      when Player::VENUE
        scores = player.scores.select{|s| s.match.venue == value and s.batted == true}
        matches = player.scores.select{|s| s.match.venue == value}.length
      when Player::VS_TEAM
        scores = player.scores.select{|s| s.inning.bow_team.abbrevation == value and s.batted == true}
        matches = player.scores.select{|s| s.inning.bow_team.abbrevation == value }.length
      end
      if scores.length >= 1
        hash['bat_stats'] = Helper.construct_bat_stats_hash2(scores)
        hash['bat_stats']['matches'] = matches
      else
        hash['bat_stats'] = {}
      end
    end
    render(:json => Oj.dump(hash))
  end

  def ball_stats2
    p_id = params[:p_id]
    hash = {}
    type, value = Player.get_stat_type(params)
    sub_type = Player.get_stat_sub_type(type, value)
    player = Player.find(p_id)
    hash['name'] = player.fullname.titleize
    hash['teamname'], hash['color'] = player.get_stat_teamname_and_color(type, value)
    hash['p_id'] = p_id
    if sub_type
      stat = BallStat.find_by(player_id: p_id, sub_type: sub_type)
      hash['ball_stats'] = {}
      hash['ball_stats'] = stat.get_hash unless stat.nil?
    else
      case type
      when Player::VENUE
        spells = player.spells.select{|s| s.match.venue == value}
        matches = player.scores.select{|s| s.match.venue == value}.length
      when Player::VS_TEAM
        spells = player.spells.select{|s| s.inning.bat_team.abbrevation == value}
        matches = player.scores.select{|s| s.inning.bow_team.abbrevation == value}.length
      end
      if spells.length >= 1
        hash['ball_stats'] = Helper.construct_ball_stats_hash2(spells)
        hash['ball_stats']['matches'] = matches
      else
        hash['ball_stats'] = {}
      end

    end
    render(:json => Oj.dump(hash))
  end

  def scores
    p_id = params[:p_id]
    player = Player.find(p_id)
    hash = {}
    scores = player.scores.where(batted: true)
    if params[:tour_class]
      tour_class_ids = Helper.get_tour_class_ids2(params[:tour_class])
      scores = scores.where(tournament_id: tour_class_ids)
    elsif params[:tour]
      scores = scores.where(tournament_id: params[:tour])
    elsif params[:team]
      scores = scores.select{|s| s.inning.bat_team.abbrevation == params[:team]}
    elsif params[:venue]
      scores = scores.select{|s| s.match.venue == params[:venue]}
    elsif params[:vs_team]
      scores = scores.select{|s| s.inning.bow_team.abbrevation == params[:vs_team]}
    end
    total_scores = []
    scores.each do |score|
      total_scores << score.score_box
    end
    hash['scores'] = total_scores
    hash['stat_options'] = player.get_stat_options
    render(:json => Oj.dump(hash))
  end

  def spells
    p_id = params[:p_id]
    player = Player.find(p_id)
    hash = {}
    spells = player.spells
    if params[:tour_class]
      tour_class_ids = Helper.get_tour_class_ids2(params[:tour_class])
      spells = spells.where(tournament_id: tour_class_ids)
    elsif params[:tour]
      spells = spells.where(tournament_id: params[:tour])
    elsif params[:team]
      spells = spells.select{|s| s.inning.bow_team.abbrevation == params[:team]}
    elsif params[:venue]
      spells = spells.select{|s| s.match.venue == params[:venue]}
    elsif params[:vs_team]
      spells = spells.select{|s| s.inning.bat_team.abbrevation == params[:vs_team]}
    end
    total_spells = []
    spells.each do |spell|
      total_spells << spell.spell_box
    end
    hash['spells'] = total_spells
    hash['stat_options'] = player.get_stat_options
    render(:json => Oj.dump(hash))
  end

  private

  def filter_params
    params.permit(:fullname, :name, :skill, :batting_hand, :bowling_hand, :bowling_style, :keeper, :country_team_id, :csl_team_id, :ipl_team_id, :born_team_id)
  end

  def convert_to_nil(a, b)
    a = nil if a == 'n/a'
    b = nil if b == 'n/a'
    return a,b
  end

end
