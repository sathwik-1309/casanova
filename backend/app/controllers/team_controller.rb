class TeamController < ApplicationController
  def teams
    hash = {}
    file = File.read(TEAM_MEDALS)
    team_medals = JSON.parse(file)
    if params[:tour_class]
      case params[:tour_class]
      when 'wt20'
        hash["wt20"] = []
        teams = Team.where(id: Squad.where(tournament_id: Tournament.wt20_ids).pluck(:team_id).uniq)
      when 'ipl'
        hash["ipl"] = []
        teams = Team.where(id: Squad.where(tournament_id: Tournament.ipl_ids).pluck(:team_id).uniq)
      when 'csl'
        hash["csl"] = []
        teams = Team.where(id: Squad.where(tournament_id: Tournament.csl_ids).pluck(:team_id).uniq)
      end
    elsif params[:t_id]
      tour = Tournament.find(params[:t_id])
      hash['teams'] = []
      teams = Squad.where(tournament_id: params[:t_id])
    else
      hash["wt20"] = []
      hash["ipl"] = []
      hash["csl"] = []
      teams = Team.all
    end

    teams.each do|team|
      temp = {}
      temp["teamname"] = team.get_teamname
      temp["abbrevation"] = team.get_abb
      if team.class == Team
        temp["is_team"] = true
        temp["squads"] = team.squads.count
        temp["color"] = team.abbrevation
      else
        temp["squads"] = 1
        temp["players"] = SquadPlayer.where(squad_id: team.id).count
        temp["color"] = Util.get_team_color(team.tournament_id, team.abbrevation)
      end
      temp["id"] = team.id
      if temp["squads"] > 0
        temp["trophies"] = team_medals[team.id.to_s]
        temp["won"], temp["played"] = team.get_won_lost
        temp["win_p"] = temp["played"] > 0 ? (temp["won"]*100/temp["played"]).round(1) : 0
        if params[:tour_class]
          hash[params[:tour_class]] << temp
        elsif params[:t_id]
          hash["teams"] << temp
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

  def squads
    json = []
    squads = Tournament.where(name: params[:tour_class]).last.squads
    squads.each do |squad|
      temp = {}
      temp['name'] = squad.get_teamname
      temp['color'] = squad.abbrevation
      temp['abbrevation'] = squad.get_abb
      players_hash = {}
      players_hash['batsmen'], players_hash['all_rounders'], players_hash['bowlers'] = [], [], []
      players = Player.where(id: SquadPlayer.where(squad_id: squad.id).pluck(:player_id))
      players.each do |player|
        case player.skill
        when "bat"
          players_hash['batsmen'] << Helper.construct_player_details(player)
        when "bow"
          players_hash['bowlers'] << Helper.construct_player_details(player)
        when "all"
          players_hash['all_rounders'] << Helper.construct_player_details(player)
        end
      end
      temp['players'] = players_hash
      json << temp
    end
    render(:json => Oj.dump(json))
  end

  def player_create
    json = {}
    json['countries'] = get_teams('wt20')
    json['ipl_teams'] = get_teams('ipl')
    json['csl_teams'] = get_teams('csl')
    json['born_teams'] = json['csl_teams']
    render(:json => Oj.dump(json))
  end

  def team_page
    team = Team.find_by_id(filter_params[:team_id])
    hash = {}
    hash['tournaments'] = team.squads.count
    hash['bat_stats'] = team.bat_stats
    hash['ball_stats'] = team.ball_stats
    hash['top_players'] = team.top_players
    captain = team.squads.last.captain.attributes.slice('id', 'name', 'fullname')
    captain['fullname'] = captain['fullname'].titleize
    hash['top_players'].each do|key, value|
      value['player']['fullname'] = value['player']['fullname'].titleize
    end
    hash['top_players']['captain'] = captain
    hash['team_stats'] = team.team_stats
    hash['meta'] = team.meta
    render(:json => Oj.dump(hash))
  end

  private

  def get_teams(tour_class)
    teams = []
    team_ids = []
    tours = Tournament.where(name: tour_class)
    tours.each do |tour|
      squads = tour.squads
      squads.each do |squad|
        if team_ids.exclude? squad.team_id
          teams << {
            "id" => squad.team_id,
            "name" => squad.team.get_abb,
            "value" => squad.team.abbrevation
          }
          team_ids << squad.team_id
        end
      end
    end
    teams
  end

  def filter_params
    params.permit(:team_id)
  end

end
