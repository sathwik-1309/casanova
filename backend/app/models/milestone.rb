class Milestone < ApplicationRecord
  belongs_to :match
  belongs_to :tournament

  # milestone types
  OVERALL ='overall'
  TOUR_CLASS = 'tour_class'
  TOUR = 'tour'
  TEAM = 'team'

  # milestone type classes
  TYPE_CLASSES = [OVERALL, TOUR_CLASS, TOUR, TEAM]

  # milestone sub_types
  BEST_SR = "best_sr"
  BEST_AVG = "best_avg"
  MOST_4S = "most_4s"
  MOST_6S = "most_6s"
  MOST_50S = "most_50s"
  MOST_100S = "most_100s"
  LOWEST_DOT_P = "lowest_dot_p"
  HIGHEST_BP = "highest_bp"
  BEST_SCORE= "best_score"
  MOST_RUNS = "most_runs"

  BEST_BOW_SR = "best_bow_sr"
  BEST_BOW_AVG = "best_bow_avg"
  BEST_ECONOMY = "best_economy"
  MOST_MAIDENS = "maidens"
  MOST_3W = "most_3w"
  MOST_5W = "most_5w"
  HIGHEST_DOT_P = "highest_dot_p"
  LOWEST_BP = "lowest_bp"
  BEST_SPELL = "best_spell"
  MOST_WICKETS = "most_wickets"

  # milestone allowed sub_types
  # top_5_runs and top_5_wickets not added in allowed for overall
  # best_score and best_spell removed in all
  ALLOWED = {
    OVERALL => [
      MOST_RUNS,
      BEST_SR,
      BEST_AVG,
      MOST_4S,
      MOST_6S,
      MOST_50S,
      MOST_100S,
      LOWEST_DOT_P,
      HIGHEST_BP,
      BEST_SCORE,
      MOST_WICKETS,
      BEST_BOW_SR,
      BEST_BOW_AVG,
      BEST_ECONOMY,
      MOST_MAIDENS,
      MOST_3W,
      MOST_5W,
      HIGHEST_DOT_P,
      LOWEST_BP,
      BEST_SPELL
    ],
    TOUR_CLASS => [
      MOST_RUNS,
      BEST_SR,
      BEST_AVG,
      MOST_4S,
      MOST_6S,
      MOST_50S,
      MOST_100S,
      LOWEST_DOT_P,
      HIGHEST_BP,
      BEST_SCORE,
      MOST_WICKETS,
      BEST_BOW_SR,
      BEST_BOW_AVG,
      BEST_ECONOMY,
      MOST_MAIDENS,
      MOST_3W,
      MOST_5W,
      HIGHEST_DOT_P,
      LOWEST_BP,
      BEST_SPELL
    ],
    TOUR => [
      MOST_RUNS,
      BEST_SR,
      BEST_AVG,
      MOST_4S,
      MOST_6S,
      MOST_50S,
      MOST_100S,
      LOWEST_DOT_P,
      HIGHEST_BP,
      BEST_SCORE,
      MOST_WICKETS,
      BEST_BOW_SR,
      BEST_BOW_AVG,
      BEST_ECONOMY,
      MOST_MAIDENS,
      MOST_3W,
      MOST_5W,
      HIGHEST_DOT_P,
      LOWEST_BP,
      BEST_SPELL
    ],
    TEAM => [
      MOST_RUNS,
      MOST_4S,
      MOST_6S,
      MOST_50S,
      MOST_100S,
      BEST_SCORE,
      MOST_MAIDENS,
      MOST_WICKETS,
      BEST_ECONOMY,
      MOST_3W,
      MOST_5W,
      BEST_SPELL
    ]
  }

  def self.get_type_class(type)
    if type == OVERALL
      return OVERALL
    elsif type =~ /wt20|ipl|csl/
      return TOUR_CLASS
    elsif type =~ /^tour_/
      return TOUR
    elsif TEAM_NAMES.include? type
      return TEAM
    end
    return nil
  end

  def self.create_nil_image(type)
    sub_types = ALLOWED[type]
    hash = {}
    raise StandardError.new("Milestone#create_nil_image: sub_types not found for type #{type}") if sub_types.nil?
    sub_types.each do|sub_type|
      hash[sub_type] = nil
    end
    return hash
  end

  def self.get_previous_image(match)
    hash = {}
    if match.id == 1
      hash[OVERALL] = Milestone.create_nil_image(OVERALL)
    else
      ml_image = MilestoneImage.find_by(match_id: match.id - 1)
      hash[OVERALL] = ml_image.image[OVERALL]
    end

    tour_class_ids = Helper.get_tour_class_ids(match.tournament_id)
    last_match_found = Match.where(tournament_id: tour_class_ids).where("id < #{match.id}").order(id: :desc).limit(1)
    type = match.tournament.name
    hash[type] = Milestone.fetch_image(last_match_found, type, TOUR_CLASS)

    last_match_found = Match.where(tournament_id: match.tournament_id).where("id < #{match.id}").order(id: :desc).limit(1)
    type = "tour_#{match.tournament_id}"
    hash[type] = Milestone.fetch_image(last_match_found, type, TOUR)

    team1 = Team.find(match.winner.team_id)
    team2 = Team.find(match.loser.team_id)
    squad1_ids = team1.squads.pluck(:id)
    squad2_ids = team2.squads.pluck(:id)

    last_match_found = Match.where(winner_id: squad1_ids).or(Match.where(loser_id: squad1_ids))
    last_match_found = last_match_found.where("id < #{match.id}").order(id: :desc).limit(1)
    type = team1.abbrevation
    hash[type] = Milestone.fetch_image(last_match_found, type, TEAM)

    last_match_found = Match.where(winner_id: squad2_ids).or(Match.where(loser_id: squad2_ids))
    last_match_found = last_match_found.where("id < #{match.id}").order(id: :desc).limit(1)
    type = team2.abbrevation
    hash[type] = Milestone.fetch_image(last_match_found, type, TEAM)

    return hash
  end

  def self.get_updated_milestone_image(match, image)
    new_image = {}
    milestones = []
    new_image[OVERALL] = Milestone.get_updated_sub_image(image[OVERALL], OVERALL)
    type = match.tournament.name
    new_image[type] = Milestone.get_updated_sub_image(image[type], type)
    type = "tour_#{match.tournament_id}"
    new_image[type] = Milestone.get_updated_sub_image(image[type], type)

    type = match.winner.team.abbrevation
    new_image[type] = Milestone.get_updated_sub_image(image[type], type)
    type = match.loser.team.abbrevation
    new_image[type] = Milestone.get_updated_sub_image(image[type], type)
    return new_image
  end

  def self.get_new_milestone_image(match)
    prev_image = Milestone.get_previous_image(match)
    new_image = Milestone.get_updated_milestone_image(match, prev_image)
    Milestone.add_new_milestones(match, prev_image, new_image)
    return new_image
  end

  def get_message_hash
    hash = {}
    squad = Score.find_by(player_id: self.value['p_id'], match_id: self.match_id).squad
    hash['color'] = squad.abbrevation
    hash['type_class'] = Milestone.get_type_class(self.ml_type)
    tour = Tournament.find(self.tournament_id)
    hash['message'], hash['previous'] = self.get_player_messasge_hash(tour, squad.get_abb, hash['type_class'])
    return hash
  end

  def get_player_messasge_hash(tour, teamname, type_class)
    p_id = self.value['p_id']
    case type_class
    when OVERALL
      part3 = OVERALL
    when TOUR_CLASS
      part3 = "in #{tour.name.upcase}"
    when TOUR
      part3 = "in this tournament"
    when TEAM
      part3 = "for #{teamname}"
    end
    part1 = Player.find(p_id).fullname.titleize
    part4 = Milestone.get_message_for_sub_type(self.sub_type)

    temp_val2 = self.value['value']
    case self.sub_type
    when BEST_SCORE
      temp_val2 = Score.find(self.value['value']['score_id']).get_runs_with_notout
    when BEST_SPELL
      temp_val2 = Spell.find(self.value['value']['spell_id']).get_fig
    end

    message = "#{part1} has #{part4.downcase} #{part3} (#{temp_val2})"
    if self.previous_value.nil?
      previous = "Previously held by None"
    else
      temp_val = self.previous_value['value']
      case self.sub_type
      when BEST_SCORE
        temp_val = Score.find(self.previous_value['value']['score_id']).get_runs_with_notout
      when BEST_SPELL
        temp_val = Spell.find(self.previous_value['value']['spell_id']).get_fig
      end
      previous = "Previously held by #{Player.find(self.previous_value['p_id']).fullname.titleize} (#{temp_val})"
    end
    return message, previous
  end

  def self.get_message_for_sub_type(sub_type)
    case sub_type
    when MOST_RUNS
      return "MOST RUNS"
    when BEST_SR
      return "BEST SR"
    when BEST_AVG
      return "BEST AVG"
    when MOST_4S
      return "MOST FOURS"
    when MOST_6S
      return "MOST SIXES"
    when MOST_50S
      return "MOST FIFTIES"
    when MOST_100S
      return "MOST HUNDREDS"
    when LOWEST_DOT_P
      return "LOWEST DOT %"
    when HIGHEST_BP
      return "HIGHEST BOUNDARY %"
    when BEST_SCORE
      return "BEST SCORE"
    when MOST_WICKETS
      return "MOST WICKETS"
    when BEST_BOW_SR
      return "BEST BOWLING SR"
    when BEST_BOW_AVG
      return "BEST BOWLING AVG"
    when BEST_ECONOMY
      return "BEST ECONOMY"
    when MOST_MAIDENS
      return "MOST MAIDENS"
    when MOST_3W
      return "MOST 3W-HAULS"
    when MOST_5W
      return "MOST 5W-HAULS"
    when HIGHEST_DOT_P
      return "HIGHEST DOT %"
    when LOWEST_BP
      return "LOWEST BOUNDARY %"
    when BEST_SPELL
      return "BEST SPELL"
    end
    raise StandardError.new("Milestone#get_message_for_sub_type: sub_type not found")
  end

  private

  def self.fetch_image(last_match_found, type, type_class)
    if last_match_found.present?
      ml_image = MilestoneImage.find_by(match_id: last_match_found.first.id)
      return ml_image.image[type]
    end
    return Milestone.create_nil_image(type_class)
  end

  def self.get_updated_sub_image(sub_image, type)
    bat_stats = BatStat.where(sub_type: type)
    ball_stats = BallStat.where(sub_type: type)
    new_sub_image = {}
    sub_image.each do|sub_type, value|
      args = nil
      field = nil
      case sub_type
      when BEST_SR
        query = bat_stats.where('runs > 80').order(sr: :desc).limit(1)
        field = 'sr'
      when BEST_AVG
        query = bat_stats.where('innings > 3').order(avg: :desc).limit(1)
        field = 'avg'
      when MOST_4S
        query = bat_stats.order(c4: :desc).limit(1)
        field = 'c4'
      when MOST_6S
        query = bat_stats.order(c6: :desc).limit(1)
        field = 'c6'
      when MOST_50S
        query = bat_stats.where('fifties > 0').order(fifties: :desc).limit(1)
        field = 'fifties'
      when MOST_100S
        query = bat_stats.where('hundreds > 0').order(hundreds: :desc).limit(1)
        field = 'hundreds'
      when MOST_RUNS
        query = bat_stats.order(runs: :desc).limit(1)
        field = 'runs'
      when HIGHEST_BP
        query = bat_stats.where('runs > 80').order(boundary_p: :desc).limit(1)
        field = 'boundary_p'
      when LOWEST_DOT_P
        query = bat_stats.where('runs > 80').order(dot_p: :asc).limit(1)
        field = 'dot_p'
      when BEST_SCORE
        player_ids = bat_stats.pluck(:player_id)
        best_ids = bat_stats.pluck(:best_id)
        query = Score.where(player_id: player_ids, inning_id: best_ids).order(runs: :desc, balls: :asc).limit(1)
        field = 'runs'
        args = BEST_SCORE
        # ball_stats
      when MOST_WICKETS
        query = ball_stats.order(wickets: :desc).limit(1)
        field = 'wickets'
      when MOST_MAIDENS
        query = ball_stats.where('maidens > 0').order(maidens: :desc).limit(1)
        field = 'maidens'
      when MOST_3W
        query = ball_stats.where('three_wickets > 0').order(three_wickets: :desc).limit(1)
        field = 'three_wickets'
      when MOST_5W
        query = ball_stats.where('five_wickets > 0').order(five_wickets: :desc).limit(1)
        field = 'five_wickets'
      when HIGHEST_DOT_P
        query = ball_stats.where('overs > 8').order(dot_p: :desc).limit(1)
        field = 'dot_p'
      when BEST_BOW_SR
        query = ball_stats.where('wickets > 1').where('overs > 8').order(sr: :asc).limit(1)
        field = 'sr'
      when BEST_BOW_AVG
        query = ball_stats.where('wickets > 1').where('overs > 8').order(avg: :asc).limit(1)
        field = 'avg'
      when BEST_ECONOMY
        query = ball_stats.where('overs > 8').order(economy: :asc).limit(1)
        field = 'economy'
      when LOWEST_BP
        query = ball_stats.where('overs > 8').order(boundary_p: :asc).limit(1)
        field = 'boundary_p'
      when BEST_SPELL
        player_ids = ball_stats.pluck(:player_id)
        best_ids = ball_stats.pluck(:best_id)
        query = Spell.where(player_id: player_ids, inning_id: best_ids).order(wickets: :desc, runs: :asc).limit(1)
        field = 'wickets'
        args = BEST_SPELL
      end
      new_sub_image[sub_type] = Milestone.get_new_sub_image(query, sub_image, sub_type, value, field, args)
    end
    return new_sub_image
  end

  def self.check_for_milestone_update(sort_param1, hash, sub_type, args=nil, stat)
    unless args.nil?
      case args
      when BEST_SCORE
        info = {
          "runs" => sort_param1,
          "balls" => stat.balls,
          "score_id" => stat.id
        }
        return true, info if hash == nil
        val = hash["value"]
        if sort_param1 > val["runs"] or (sort_param1==val["runs"] and (stat.balls<val["balls"]))
          return true, info
        end
      when BEST_SPELL
        info = {
          "wickets" => sort_param1,
          "runs" => stat.runs,
          "spell_id" => stat.id
        }
        return true, info if hash == nil
        val = hash["value"]
        if sort_param1 > val["wickets"] or (sort_param1==val["wickets"] and (stat.runs<val["runs"]))
          return true, info
        end
      end
      return false
    end
    return true, sort_param1 if hash == nil
    highest = [MOST_RUNS, BEST_SR, BEST_AVG, MOST_4S, MOST_6S, MOST_50S, MOST_100S, HIGHEST_BP, MOST_WICKETS, MOST_MAIDENS, MOST_3W, MOST_5W, HIGHEST_DOT_P]
    lowest = [LOWEST_DOT_P, BEST_BOW_SR, BEST_BOW_AVG, BEST_ECONOMY, LOWEST_BP]
    # TOP_5_RUNS, TOP_5_WICKETS
    if highest.include? sub_type
      if sort_param1 > hash["value"]
        return true, sort_param1
      end
    else
      if sort_param1 < hash["value"]
        return true, sort_param1
      end
    end
    return false
  end

  def self.get_new_sub_image(query, sub_image, sub_type, value_hash, field, args)
    if query.present?
      stat = query.first
      number = stat.send(field.to_sym)
      change, info = Milestone.check_for_milestone_update(number, value_hash, sub_type, args, stat)
      if change
        json = {
          "p_id" => stat.player_id,
          "value" => info
        }
        return json
      end
    end
    return sub_image[sub_type]
  end

  def self.add_new_milestones(match, prev_image, new_image)
    new_image.each do |type, hash|
      hash.each do |sub_type, value|
        if value != prev_image[type][sub_type]
          if prev_image[type][sub_type].nil? or (value["p_id"]!=prev_image[type][sub_type]["p_id"])
            m = Milestone.new
            m.match_id = match.id
            m.tournament_id = match.tournament_id
            m.ml_type = type
            m.sub_type = sub_type
            m.value = value
            m.previous_value = prev_image[type][sub_type]
            in_match = false
            match_players = Score.where(match: match.id).pluck(:player_id)
            if match_players.include? value["p_id"]
              in_match = true
            end
            m.in_match = in_match
            m.tags = [type, value["p_id"]]
            Uploader.add_new_milestone(m)
          end
        end
      end
    end
  end

end
