class TeamController < ApplicationController
  def teams
    hash = {}
    file = File.read(TEAM_MEDALS)
    team_medals = JSON.parse(file)
    if params[:tour_class]
      case params[:tour_class]
      when 'wt20'
        hash["wt20"] = []
        teams = Team.where(id: Squad.where(tournament_id: WT20_IDS).pluck(:team_id).uniq)
      when 'ipl'
        hash["ipl"] = []
        teams = Team.where(id: Squad.where(tournament_id: IPL_IDS).pluck(:team_id).uniq)
      when 'csl'
        hash["csl"] = []
        teams = Team.where(id: Squad.where(tournament_id: CSL_IDS).pluck(:team_id).uniq)
      end
    elsif params[:t_id]
      tour = Tournament.find(params[:t_id])
      hash[tour.name] = []
      teams = Team.where(id: Squad.where(tournament_id: params[:t_id]).pluck(:team_id))
    else
      hash["wt20"] = []
      hash["ipl"] = []
      hash["csl"] = []
      teams = Team.all
    end

    teams.each do|team|
      temp = {}
      temp["teamname"] = team.get_teamname
      temp["squads"] = team.squads.count
      if temp["squads"] > 0
        temp["color"] = team.abbrevation
        temp["trophies"] = team_medals[team.id.to_s]
        temp["won"], temp["played"] = team.get_won_lost
        temp["win_p"] = (temp["won"]*100/temp["played"]).round(1)
        if params[:tour_class]
          hash[params[:tour_class]] << temp
        else
          if team.id <= 10
            hash["wt20"] << temp
          elsif team.id >= 31
            hash["csl"] << temp
          else
            hash["ipl"] << temp
          end
        end
      end
    end

    render(:json => Oj.dump(hash))
  end
end
