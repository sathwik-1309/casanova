class Tournament < ApplicationRecord
    has_many :squads
    has_many :balls
    has_many :overs
    has_many :innings
    has_many :matches
    has_many :wickets
    has_many :scores
    has_many :spells
    has_many :partnerships
    has_many :performances
    has_many :schedules

    after_create :populate_groups_in_seeding

    def populate_groups_in_seeding
        return if self.groups != []
        groups = Util.get_tournament_json(self.id)
        self.groups = groups["groups"]
        self.save!
    end

    def winners
        return nil unless self.medals['gold']
        return Squad.find(self.medals['gold'])
    end
    def runners
        return nil unless self.medals['silver']
        return Squad.find(self.medals['silver'])
    end
    def pots
        return Player.find(self.pots_id)
    end
    def mvp
        return Player.find(self.mvp_id)
    end
    def most_runs
        return Player.find(self.most_runs_id)
    end
    def most_wickets
        return Player.find(self.most_wickets_id)
    end

    def get_tour_font
        return "#{self.name}_#{self.id}"
    end

    def get_tour_with_season
        return "#{self.name.upcase}-#{self.season}"
    end

    def tournament_box
        hash = {}
        hash["tour_class"] = "#{self.name.upcase}-#{self.season}"
        hash["t_id"] = self.id
        if self.medals != {}
            hash["w_teamname"] = self.winners.get_teamname
            hash["w_color"] = self.winners.abbrevation
            hash["pots"] = self.pots.fullname.titleize
        end
        hash["matches"] = Match.where(tournament_id: self.id).count
        return hash
    end

    def get_mvp_sorted_hash
        scores = Score.where(tournament_id: self.id)
        points_hash = {}
        scores.each do|score|
            p_id = score.player_id
            p = Player.find(p_id)
            points = p.get_mvp_points(score.match_id)
            if points_hash[p_id]
                points_hash[p_id] += points
            else
                points_hash[p_id] = points
            end
        end
        points_hash
    end

    def self.wt20_ids
        Tournament.where(name: 'wt20').pluck(:id)
    end

    def self.ipl_ids
        Tournament.where(name: 'ipl').pluck(:id)
    end

    def self.csl_ids
        Tournament.where(name: 'csl').pluck(:id)
    end

    def self.validate_tournament_json(json)
        if TOURNAMENT_NAMES.exclude? json['name']
            raise StandardError.new("Cannot create Tour with name #{json['name']}")
        end
        teams = []
        teams_per_group = json['groups'][0].length
        json['groups'].each do |group|
            if group.length != teams_per_group
                raise StandardError.new("Groups unequal")
            end
            group.each do|team|
                if teams.include? team
                    raise StandardError.new("team #{team} duplicated")
                end
                teams << team
            end
        end
        if teams.sort != json['squads'].keys.sort
            raise StandardError.new("Teams not matching with squads")
        end
    end

    def individual_bat_stats
        arr = []
        bat_stats = BatStat.where(sub_type: "tour_#{self.id}").where("runs > 0").order(runs: :desc)
        bat_stats.each do |stat|
            temp = stat.attributes.slice('matches', 'innings', 'runs', 'sr', 'avg', 'c4', 'c6', 'thirties', 'fifties', 'hundreds', 'boundary_p', 'dot_p')
            temp['player'] = stat.player.attributes.slice('id', 'name', 'fullname')
            best = Inning.find_by_id(stat.best_id).scores.find_by(player_id: stat.player_id)
            temp['best'] = best.score_box            
            squad = SquadPlayer.find_by(tournament_id: self.id, player_id: stat.player_id).squad
            temp['color'] = Util.get_team_color(self.id ,squad.abbrevation)
            temp['teamname'] = squad.get_abb
            arr << temp
        end
        arr
    end

    def individual_ball_stats
        arr = []
        stats = BallStat.where(sub_type: "tour_#{self.id}").where("overs > 0").order(wickets: :desc, economy: :asc)
        stats.each do |stat|
            temp = stat.attributes.slice('matches', 'innings', 'overs', 'maidens', 'wickets', 'economy', 'sr', 'avg', 'three_wickets', 'five_wickets', 'boundary_p', 'dot_p')
            temp['player'] = stat.player.attributes.slice('id', 'name', 'fullname')
            best = Inning.find_by_id(stat.best_id).spells.find_by(player_id: stat.player_id)
            temp['best'] = best.spell_box
            squad = SquadPlayer.find_by(tournament_id: self.id, player_id: stat.player_id).squad
            temp['color'] = Util.get_team_color(self.id ,squad.abbrevation)
            temp['teamname'] = squad.get_abb
            arr << temp
        end
        arr
    end

    def self.create_using_json(json)
        t = Tournament.new(name: json['name'])
        t.season = Tournament.where(name: json['name']).last.season + 1
        t.id = Tournament.last.id + 1
        t.ongoing = true
        groups = []
        json['groups'].each do |group|
            temp = []
            group.each do |team_abb|
                temp << Team.find_by_abbrevation(team_abb).id
            end
            groups << temp
        end
        t.groups = groups
        t.save!
        json['squads'].each do |key, val|
            team = Team.find_by_abbrevation(key)
            s = Squad.new(name: team.name, abbrevation: team.abbrevation, tournament_id: t.id,
                          captain_id: val['captain_id'], keeper_id: val['keeper_id'], team_id: team.id)
            s.save!
            val['players'].each do |p_id|
                sp = SquadPlayer.new(player_id: p_id, squad_id: s.id, team_id: s.team_id, tournament_id: t.id)
                sp.save!
            end
        end
    end
end
