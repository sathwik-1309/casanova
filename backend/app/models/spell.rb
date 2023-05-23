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
end
