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
        m_id = self.match_id
        p_id = self.player_id
        hash = {}
        match = Match.find(m_id)
        hash["type"] = 'score'
        hash["tour"] = match.get_tour_font
        hash["name"] = Util.case(self.player.fullname, match.tournament_id)
        hash["score"] = self.get_runs_with_notout
        hash["balls"] = self.balls
        hash["dots"] = self.dots
        hash["ones"] = self.c1
        hash["twos"] = self.c2
        hash["threes"] = self.c3
        hash["fours"] = self.c4
        hash["sixes"] = self.c6
        hash["sr"] = self.sr
        hash["color"] = self.squad.abbrevation
        hash["p_id"] = p_id
        return hash
    end

end
