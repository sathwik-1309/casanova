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
        hash["color"] = Util.get_team_color(self.tournament_id, self.squad.abbrevation)
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
        hash["position"] = self.position
        hash["id"] = self.id
        hash["match_id"] = self.match_id
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

    def phase_box(balls)
        h = {}
        h['powerplay'] = self.phase_box_hash(balls, 'powerplay')
        h['middle'] = self.phase_box_hash(balls, 'middle')
        h['death'] = self.phase_box_hash(balls, 'death')
        return h
    end

    def phase_box_hash(balls, phase)
        case phase
        when "powerplay"
            balls = balls.where('delivery < 6')
        when "middle"
            balls = balls.where('delivery >= 6.0 and delivery < 15')
        when "death"
            balls = balls.where('delivery >= 15.0')
        end
        return nil unless balls.present?
        hash = Score.empty_score_hash
        balls.each do |ball|
            hash = Score.update_score_hash(ball, hash)
        end
        hash["sr"] = Util.get_sr(hash["runs"], hash["balls"])
        hash["color"] = Util.get_team_color(self.tournament_id, self.squad.abbrevation)
        return hash
    end

    def vs_bowlers(balls)
        arr = []
        bowlers = {}
        balls.each do |ball|
            bowler_id = ball.bowler_id
            bowlers[bowler_id] = Score.empty_score_hash unless bowlers.has_key? bowler_id
            bowlers[bowler_id] = Score.update_score_hash(ball, bowlers[bowler_id])
        end
        bowlers.each do |k,v|
            v["sr"] = Util.get_sr(v["runs"], v["balls"])
            v["color"] = Util.get_team_color(self.tournament_id, self.squad.abbrevation)
            v["bowler_id"] = k
            v["bowler_name"] = Player.find(k).name.titleize
            v["bowler_color"] = Util.get_team_color(self.tournament_id, self.inning.bow_team.abbrevation)
            arr << v
        end
        return arr
    end

    private

    def self.empty_score_hash
        h = {}
        h["runs"] = 0
        h["balls"] = 0
        h["fours"] = 0
        h["sixes"] = 0
        h["dots"] = 0
        h
    end

    def self.update_score_hash(ball, hash)
        hash["runs"] += (ball.runs - ball.extras)
        hash["balls"] += 1 if ball.extra_type != "wd"
        hash["dots"] += 1 if ball.category == "c0"
        hash["fours"] += 1 if ball.category == "c4"
        hash["sixes"] += 1 if ball.category == "c6"
        return hash
    end

end
