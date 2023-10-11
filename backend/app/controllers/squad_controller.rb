class SquadController < ApplicationController

  def squad_page
    squad = Squad.find_by_id(filter_params[:squad_id])
    hash = {}
    info = {}
    meta = {
      "id" => squad.id,
      "color" => squad.abbrevation,
      "abbrevation" => squad.get_abb,
      "teamname" => squad.get_teamname,
      "tour" => squad.tournament.get_tour_with_season
    }
    hash['schedule'] = squad.schedule
    hash['bat_stats'] = squad.bat_stats
    hash['ball_stats'] = squad.ball_stats
    hash['top_players'] = squad.top_players
    captain = squad.captain.attributes.slice('id', 'name', 'fullname')
    captain['fullname'] = captain['fullname'].titleize
    hash['top_players']['captain'] = captain
    hash['top_players'].each do|key, value|
      if value['player']
        value['player']['fullname'] = value['player']['fullname'].titleize
      end
    end

    hash['meta'] = meta
    render(:json => Oj.dump(hash))
  end

  private

  def filter_params
    params.permit(:squad_id)
  end

end