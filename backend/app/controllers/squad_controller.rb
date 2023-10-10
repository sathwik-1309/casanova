class SquadController < ApplicationController

  def squad_page
    squad = Squad.find_by_id(filter_params[:squad_id])
    hash = {}
    info = {}
    meta = {
      "id" => squad.id,
      "color" => squad.abbrevation,
      "abbrevation" => squad.get_abb,
      "teamname" => squad.get_teamname
    }
    info['captain'] = squad.captain.attributes.slice('id', 'name', 'fullname')
    hash['schedule'] = squad.schedule
    hash['bat_stats'] = squad.bat_stats
    hash['ball_stats'] = squad.ball_stats
    hash['top_players'] = squad.top_players
    hash['info'] = info
    render(:json => Oj.dump(hash))
  end

  private

  def filter_params
    params.permit(:squad_id)
  end

end