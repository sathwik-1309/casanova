class Spell < ApplicationRecord
    belongs_to :player
    belongs_to :squad
    belongs_to :inning
    belongs_to :match
    belongs_to :tournament

    def get_overs
        return Over.where(inning_id: self.inning_id, bowler_id: self.player_id)
    end
    def get_fig
        return "#{self.wickets} - #{self.runs}"
    end

    def spell_box
        m_id = self.match_id
        p_id = self.player_id
        hash = {}
        match = Match.find(m_id)
        hash["type"] = 'spell'
        hash["tour"] = match.get_tour_font
        hash["name"] = Util.case(self.player.fullname, match.tournament_id)
        hash["fig"] = self.get_fig
        hash["overs"] = self.overs
        hash["dots"] = self.dots
        hash["ones"] = self.c1
        hash["fours"] = self.c4
        hash["sixes"] = self.c6
        hash["economy"] = self.economy
        hash["maidens"] = self.maidens
        hash["color"] = self.squad.abbrevation
        hash["p_id"] = p_id
        return hash
    end

    def get_mvp_points_spell(match_eco, match_bow_sr)
        # Points = (O*E) + (W*S1)
        rel_eco = (match_eco/self.economy).round(2)
        rel_sr = self.sr.nil? ? 0 : (match_bow_sr/self.sr).round(2)
        rel_eco = 0 if rel_eco < 0.85
        points = (Util.overs_to_balls(self.overs) * rel_eco * 0.8) + (self.wickets * rel_sr)
        return points.round(2)
    end
end
