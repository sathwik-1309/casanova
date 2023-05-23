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
end
