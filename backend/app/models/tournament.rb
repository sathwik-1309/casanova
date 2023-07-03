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

    def winners
        return Squad.find(self.winners_id)
    end
    def runners
        return Squad.find(self.runners_id)
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


    def validate
        status = true
        errors = []

        unless TOURNAMENT_NAMES.include?(self.name)
            status = false
            errors << "name cannot be #{self.name}"
        end

        if self.winners_id && Squad.all.pluck(:id).exclude?(self.winners_id)
            status = false
            errors << "winners_id not a foreign key: #{self.winners_id}"
        end
        return status,errors
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
        if self.winners_id != nil
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
end
