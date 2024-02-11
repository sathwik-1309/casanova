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
    hash['ranking'] = team.get_ranking_hash
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

  def head_to_head
    team = params[:team_id].present? ? Team.find_by_id(params[:team_id]) : Squad.find_by_id(params[:squad_id]).team
    squad_ids = team.squads.pluck(:id)
    matches = team.get_matches
    hash = {}
    matches.each do |match|
      if squad_ids.include? match.winner_id
        hash[match.loser.team_id] = [0,0] unless hash.has_key? match.loser.team_id
        hash[match.loser.team_id][0] += 1
      else
        hash[match.winner.team_id] = [0,0] unless hash.has_key? match.winner.team_id
        hash[match.winner.team_id][1] += 1
      end
    end
    arr = []
    hash.each do |key, value|
      temp = {}
      temp['record'] = value.join(' - ')
      if value[0] > value[1]
        temp['record_color'] = 'green'
      elsif value[1] > value[0]
        temp['record_color'] = 'red'
      else
        temp['record_color'] = 'gray'
      end
      temp['vs_team'] = Team.find(key).get_abb
      temp['win_p'] = (value[0]*100/(value[0]+value[1])).to_i
      temp['won'] = value[0]
      temp['lost'] = value[1]
      temp['team_id'] = key
      arr << temp
    end
    ret = {}
    arr = arr.sort_by{|h| [-h['win_p'], -h['won'], h['lost'] ]}
    ret['head_to_head'] = arr
    ret['team_id'] = team.id
    render(:json => Oj.dump(ret))
  end

  def head_to_head_detailed
    team1 = params[:team1].present? ? Team.find(params[:team1]) : Squad.find(params[:squad1]).team
    team2 = params[:team2].present? ? Team.find(params[:team2]) : Squad.find(params[:squad2]).team
    hash = Team.head_to_head_boxes_hash(team1, team2)
    render(:json => Oj.dump(hash))
  end

  def leaderboard
    rformats = ['wt20', 'csl']
    hash = {}
    rformats.each do |rformat|
      hash[rformat] = {}
      tls = TLeaderboard.where(rformat: rformat)
      history = []
      leaderboard = []
      tls.each do |tl|
        temp = tl.attributes.slice('matches', 'highest_rating', 'team_id', 'match_id')
        team = tl.team
        temp['name'] = team.get_teamname
        temp['color'] = team.abbrevation
        history << temp
        tl_dict = leaderboard.find{|h| h['team_id'] == tl.team_id}
        if tl_dict.nil?
          leaderboard << {'team_id'=>tl.team_id, 'times'=>0, 'matches'=>0, 'highest_rating'=>0, 'name'=>temp['name'], 'color'=>temp['color']}
          tl_dict = leaderboard[-1]
        end
        tl_dict['times'] += 1
        tl_dict['matches'] += tl.matches
        tl_dict['highest_rating'] = tl.highest_rating if tl.highest_rating > tl_dict['highest_rating']
      end
      leaderboard = leaderboard.sort_by{|l| -l['matches']}
      hash[rformat]['history'] = history
      hash[rformat]['leaderboard'] = leaderboard
    end
    render(:json => Oj.dump(hash))
  end

  def select_squads_home
    teams = Team.where("id between 30 and 43")
    arr = []
    teams.each do |team|
      hash = team.meta
      hash['selected_players'] = CurrentSquad.first.send(team.abbrevation.to_sym).length
      arr << hash
    end
    render(:json => Oj.dump(arr))
  end

  def select_squads_action
    begin
      team_id = filter_params[:team_id]
      team = Team.find_by_id(team_id)
      css = CurrentSquad.first
      cs = css.send(Team.find(team_id).abbrevation.to_sym)
      if filter_params[:add]
        cs << filter_params[:player_id]
        css.update(team.abbrevation => cs)
      else
        cs.delete(filter_params[:player_id])
        css.update(team.abbrevation => cs)
      end
      
      css.save!
      render_200("Updated")
    rescue StandardError => ex
      render_202(ex.message)
    end
  end

  def select_squads
    team_id = filter_params[:team_id]
    team = Team.find(team_id)
    hash = {}
    selected = CurrentSquad.first.send(team.abbrevation.to_sym)
    players = Player.where(id: selected)
    batters = []
    all_rounders = []
    bowlers = []
    players.each do |player|
      case player.skill
      when 'bat'
        batters << player.profile_hash2
      when 'bow'
        bowlers << player.profile_hash2
      when 'all'
        all_rounders << player.profile_hash2
      end
    end
    hash['selected'] = {
      'total' => batters.length + all_rounders.length + bowlers.length,
      'batsmen' => {
        'count' => batters.length,
        'players' => batters
      },
      'all_rounders' => {
        'count' => all_rounders.length,
        'players' => all_rounders
      },
      'bowlers' => {
        'count' => bowlers.length,
        'players' => bowlers
      }
    }

    born = Player.where(born_team_id: team_id).filter{|p| selected.exclude? p.id}
    batters = []
    all_rounders = []
    bowlers = []
    born.each do |player|
      case player.skill
      when 'bat'
        batters << player.profile_hash2
      when 'bow'
        bowlers << player.profile_hash2
      when 'all'
        all_rounders << player.profile_hash2
      end
    end
    hash['pool'] = {
      'total' => batters.length + all_rounders.length + bowlers.length,
      'batsmen' => {
        'count' => batters.length,
        'players' => batters
      },
      'all_rounders' => {
        'count' => all_rounders.length,
        'players' => all_rounders
      },
      'bowlers' => {
        'count' => bowlers.length,
        'players' => bowlers
      }
    }
    cs = CurrentSquad.first
    all_selected = cs.jan + cs.feb + cs.mar + cs.apr + cs.may + cs.june + cs.july + cs.aug + cs.sept + cs.oct + cs.nov + cs.dec
    unselected = Player.all.pluck(:id) - all_selected
    batters = []
    all_rounders = []
    bowlers = []
    Player.where(id: unselected).each do |player|
      case player.skill
      when 'bat'
        batters << player.profile_hash2
      when 'bow'
        bowlers << player.profile_hash2
      when 'all'
        all_rounders << player.profile_hash2
      end
    end
    
    hash['unselected'] = {
      'total' => batters.length + all_rounders.length + bowlers.length,
      'batsmen' => {
        'count' => batters.length,
        'players' => batters
      },
      'all_rounders' => {
        'count' => all_rounders.length,
        'players' => all_rounders
      },
      'bowlers' => {
        'count' => bowlers.length,
        'players' => bowlers
      }
    }
    hash['color'] = team.abbrevation
    hash['teamname'] = team.get_teamname
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
    params.permit(:team_id, :add, :player_id)
  end

end
