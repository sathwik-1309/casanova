class Score < ApplicationRecord
    belongs_to :player
    belongs_to :squad
    belongs_to :inning
    belongs_to :match
    belongs_to :tournament

    def wicket
        return Wicket.find_by(inning_id: self.inning_id, batsman_id: self.player_id)
    end
    def get_runs_with_notout
        if self.not_out
            return "#{self.runs}*"
        else
            return "#{self.runs}"
        end
    end

    def score_box
        hash = {}
        hash["type"] = 'score'
        hash["color"] = self.squad.abbrevation
        hash["vs_team"] = self.inning.bow_team.get_abb
        hash["venue"] = self.match.venue.upcase
        hash["p_id"] = self.player_id
        hash["tour"] = self.match.get_tour_font
        hash["name"] = Util.case(self.player.fullname, self.match.tournament_id)
        hash["batted"] = self.batted
        return hash unless self.batted
        hash["score"] = self.get_runs_with_notout
        hash["balls"] = self.balls
        hash["dots"] = self.dots
        hash["ones"] = self.c1
        hash["twos"] = self.c2
        hash["threes"] = self.c3
        hash["fours"] = self.c4
        hash["sixes"] = self.c6
        hash["sr"] = self.sr
        return hash
    end

    def get_mvp_points_score(match_sr)
        # Points = (R+5N)*S
        not_out = self.not_out ? 5 : 1
        not_out = 1 if self.balls <= 7
        # relative strike-rate
        rel_sr = self.sr.nil? ? 0 : (self.sr/match_sr).round(2)
        points = (self.runs + not_out) * rel_sr
        return points.round(2)
    end

    def self.get_better_score(score1, score2)
        return score2 if score1.nil?
        return score1 if score1.runs > score2.runs
        return score2 if score1.runs < score2.runs
        return score1 if score1.balls < score2.balls
        return score2 if score1.balls > score2.balls
        return score1
    end

end
