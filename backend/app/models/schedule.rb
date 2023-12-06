class Schedule < ApplicationRecord
  belongs_to :tournament

  def squad1
    Squad.find_by_id(self.squad1_id)
  end
  def squad2
    Squad.find_by_id(self.squad2_id)
  end

  def match
    Match.find_by_id(self.match_id)
  end

  def self.create_tournament_schedules(json)
    t_id = json['t_id']
    default_stage = json['default_stage']
    matches = json['matches']
    order = 1
    matches.each do |match|
      s = Schedule.new
      squad1 = Squad.find_by(abbrevation: match['team1'], tournament_id: t_id)
      squad2 = Squad.find_by(abbrevation: match['team2'], tournament_id: t_id)
      s.squad1_id = squad1.id
      s.squad2_id = squad2.id
      s.venue = match['venue']
      s.stage = match['stage'].present? ? match['stage'] : default_stage
      s.completed = false
      s.order = order
      s.tournament_id = t_id
      order += 1
      s.save!
    end
  end

  def match
    Match.find_by_id(self.match_id)
  end

  def schedule_box
    temp = self.attributes.slice('order', 'completed', 'match_id')
    temp['schedule_id'] = self.id
    temp['venue'] = self.venue.titleize
    temp['stage'] = self.stage.titleize
    temp['squad1'] = self.squad1.squad_box
    temp['squad2'] = self.squad2.squad_box
    temp['font'] = self.tournament.get_tour_font
    if self.completed
      temp['result'] = self.match.result_statement
      temp['result_color'] = Util.get_team_color(self.tournament_id, self.match.winner.abbrevation)
      if self.match.winner_id == temp['squad1']['id']
        temp['squad1']['result'] = 'won'
        temp['squad2']['result'] = 'lost'
      else
        temp['squad1']['result'] = 'lost'
        temp['squad2']['result'] = 'won'
      end
    end
    temp
  end

  def pre_match_hash(team1=nil, team2=nil, match_id=nil)
    team1 = team1.nil? ? self.squad1.team : team1
    team2 = team2.nil? ? self.squad2.team : team2
    match_id = match_id.nil? ? self.match_id : match_id
    
    hash = Team.head_to_head_boxes_hash(team1, team2, match_id)
    h2h_record = hash['h2h_record']
    h2h_record_box = []
    h2h_record_box << {
      'team_id' => team1.id,
      'color' => team1.abbrevation,
      'teamname' => team1.get_teamname,
      'won' => h2h_record[0]
    }
    h2h_record_box << {
      'team_id' => team2.id,
      'color' => team2.abbrevation,
      'teamname' => team2.get_teamname,
      'won' => h2h_record[1]
    }
    hash['h2h_record_box'] = h2h_record_box
    squad_ids1 = team1.squads.pluck(:id)
    squad_ids2 = team2.squads.pluck(:id)
    ids = squad_ids1+squad_ids2
    matches = Match.where('winner_id IN (?) AND loser_id IN (?)', ids, ids).where("id < ?", match_id)
    runs_array = []
    wickets_array = []
    matches.each do |match|
      match.scores.each do |score|
        if score.batted
          runs_hash = runs_array.find{|hash| hash['id'] == score.player_id}
          if runs_hash.nil?
            runs_array << {'id'=>score.player_id, 'runs'=>0, 'name'=> score.player.fullname.titleize, 'color'=>score.inning.bat_team.abbrevation, 'team_id'=>score.inning.bat_team.team_id}
            runs_hash = runs_array[-1]
          end
          runs_hash['runs'] += score.runs
        end
      end
      match.spells.each do |spell|
        wickets_hash = wickets_array.find{|hash| hash['id'] == spell.player_id}
        if wickets_hash.nil?
          wickets_array << {'id'=>spell.player_id, 'wickets'=>0, 'name'=> spell.player.fullname.titleize, 'color'=>spell.inning.bow_team.abbrevation, 'team_id'=>spell.inning.bow_team.team_id}
          wickets_hash = wickets_array[-1]
        end
        wickets_hash['wickets'] += spell.wickets
      end
    end

    team1_runs_array = []
    team2_runs_array = []
    team1_wickets_array = []
    team2_wickets_array = []
    runs_array.sort_by{|hash| -hash['runs']}.each do |runs_hash|
      if runs_hash['team_id'] == team1.id
        team1_runs_array << runs_hash
      else
        team2_runs_array << runs_hash
      end
    end

    wickets_array.sort_by{|hash| -hash['wickets']}.each do |wickets_hash|
      if wickets_hash['team_id'] == team1.id
        team1_wickets_array << wickets_hash
      else
        team2_wickets_array << wickets_hash
      end
    end
    most_runs = []
    most_wickets = []
    most_runs << team1_runs_array.slice(0,3)
    most_runs << team2_runs_array.slice(0,3)
    most_wickets << team1_wickets_array.slice(0,3)
    most_wickets << team2_wickets_array.slice(0,3)
    hash['most_runs'] = most_runs
    hash['most_wickets'] = most_wickets
    rankings = {}
    if self.squad1.present?
      players1 = self.squad1.players 
      players2 = self.squad2.players
      tour_name = self.tournament.name
    else
      squads1 = team1.squads
      players1 = []
      squads1.each do |sq|
        players1 += sq.players
      end
      squads2 = team2.squads
      players2 = []
      squads2.each do |sq|
        players2 += sq.players
      end
      tour_name = squads2[-1].tournament.name
    end

    players1 = players1.uniq
    players2 = players2.uniq
    
    bat_rankings = []
    ball_rankings = []
    all_rankings = []
    bat_image = PlayerRatingImage.where(rtype: RTYPE_BAT, rformat: tour_name).where("match_id < ?", match_id).last
    ball_image = PlayerRatingImage.where(rtype: RTYPE_BALL, rformat: tour_name).where("match_id < ?", match_id).last
    all_image = PlayerRatingImage.where(rtype: RTYPE_ALL, rformat: tour_name).where("match_id < ?", match_id).last
    players1.each do |player|
      bat_rankings << {
        'id' => player.id,
        'ranking' => bat_image.get_rank(player.id),
        'team_id' => team1.id,
        'color' => team1.abbrevation,
        'name' => player.fullname.titleize
      }
      ball_rankings << {
        'id' => player.id,
        'ranking' => ball_image.get_rank(player.id),
        'team_id' => team1.id,
        'color' => team1.abbrevation,
        'name' => player.fullname.titleize
      }
      all_rankings << {
        'id' => player.id,
        'ranking' => all_image.get_rank(player.id),
        'team_id' => team1.id,
        'color' => team1.abbrevation,
        'name' => player.fullname.titleize
      }
    end
    players2.each do |player|
      bat_rankings << {
        'id' => player.id,
        'ranking' => bat_image.get_rank(player.id),
        'team_id' => team2.id,
        'color' => team2.abbrevation,
        'name' => player.fullname.titleize
      }
      ball_rankings << {
        'id' => player.id,
        'ranking' => ball_image.get_rank(player.id),
        'team_id' => team2.id,
        'color' => team2.abbrevation,
        'name' => player.fullname.titleize
      }
      all_rankings << {
        'id' => player.id,
        'ranking' => all_image.get_rank(player.id),
        'team_id' => team2.id,
        'color' => team2.abbrevation,
        'name' => player.fullname.titleize
      }
    end
    hash['bat_rankings'] = bat_rankings.filter{|h| h['ranking'] != nil }.sort_by{|hash| hash['ranking']}.slice(0,3)
    hash['bow_rankings'] = ball_rankings.filter{|h| h['ranking'] != nil }.sort_by{|hash| hash['ranking']}.slice(0,3)
    hash['all_rankings'] = all_rankings.filter{|h| h['ranking'] != nil }.sort_by{|hash| hash['ranking']}.slice(0,3)
    #hash['squads'] = self.pre_match_squads
    return hash
  end

  def pre_match_squads_hash
    players1 = self.squad1.players
    players2 = self.squad2.players
    arr1 = []
    arr2 = []
    
    players1.each do |player|
      temp = self.pre_match_squads_helper(player, self.squad1.team)
      arr1 << temp
    end
    
    players2.each do |player|
      temp = self.pre_match_squads_helper(player, self.squad2.team)
      arr2 << temp
    end
    arr1 = arr1.sort_by{|h| -h['runs']}
    arr2 = arr2.sort_by{|h| -h['runs']}
    return [arr1, arr2]
  end

  def pre_match_squads_helper(player, team)
    skill = player.skill
    name = player.fullname.titleize
    match_id = self.match_id.nil? ? Match.last.id + 1 : self.match_id
    skill = 'wk' if self.squad1.keeper_id == player.id or self.squad2.keeper_id == player.id
    name = "#{name} (c)"if self.squad1.captain_id == player.id or self.squad2.captain_id == player.id
    bat_image = PlayerRatingImage.where(rtype: RTYPE_BAT, rformat: self.tournament.name).where("match_id < ?", match_id).last
    ball_image = PlayerRatingImage.where(rtype: RTYPE_BALL, rformat: self.tournament.name).where("match_id < ?", match_id).last
    all_image = PlayerRatingImage.where(rtype: RTYPE_ALL, rformat: self.tournament.name).where("match_id < ?", match_id).last
    tour_runs = self.tournament.scores.where("match_id < ?", match_id).where(player_id: player.id, batted: true).pluck(:runs).sum
    tour_wickets = self.tournament.spells.where("match_id < ?", match_id).where(player_id: player.id).pluck(:wickets).sum
    tour_name = self.tournament.name
    case tour_name
    when 'wt20'
      t_ids = Tournament.wt20_ids
    when
      t_ids = Tournament.csl_ids
    end
    runs = player.scores.where(tournament_id: t_ids).where(batted: true).where("match_id < ?", match_id).pluck(:runs).sum
    wickets = player.spells.where(tournament_id: t_ids).where("match_id < ?", match_id).pluck(:wickets).sum
    temp = {
      'id' => player.id,
      'color' => team.abbrevation,
      'team_id' => team.id,
      'skill' => skill,
      'skill_name' => Util.get_skillname(skill),
      'name' => name,
      'runs' => runs,
      'wickets' => wickets,
      'tour_runs' => tour_runs,
      'tour_wickets' => tour_wickets
    }
    temp['bat_rank'], temp['bat_rating'] = bat_image.get_rank_and_rating(player.id)
    temp['bow_rank'], temp['bow_rating'] = ball_image.get_rank_and_rating(player.id)
    temp['all_rank'], temp['all_rating'] = all_image.get_rank_and_rating(player.id)
    return temp
  end

end
