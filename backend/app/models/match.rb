class Match < ApplicationRecord
    has_many :balls
    has_many :overs
    has_many :innings
    has_many :wicket
    has_many :scores
    has_many :spells
    has_many :scores
    has_many :spells
    has_many :partnerships
    has_many :performances
    belongs_to :tournament

    after_commit do
        unless self.runs.nil?
            self.update_stats
            Uploader.update_milestone_image(self)
            self.update_tournament
        end
    end

    def inn1
        return Inning.find(self.inn1_id)
    end
    def inn2
        return Inning.find(self.inn2_id)
    end
    def winner
        return Squad.find(self.winner_id)
    end
    def loser
        return Squad.find(self.loser_id)
    end
    def toss
        return Squad.find(self.toss_id)
    end
    def motm
        return Player.find(self.motm_id)
    end

    def get_tour_font
        return "#{Tournament.find(self.tournament_id).name}_#{self.tournament_id}"
    end

    def self.match_box(m_id)
        match = Match.find(m_id)
        hash = {}
        inn1 = match.inn1
        inn2 = match.inn2
        hash["inn1"] = {}
        hash["inn1"]["teamname"] = inn1.bat_team.get_abb
        hash["inn1"]["won"] = match.winner_id == inn1.bat_team_id
        if match.winner_id == inn1.bat_team_id
            hash["inn1"]["score"] = "⭐️ #{Util.get_score(inn1.score, inn1.for)}"
        else
            hash["inn1"]["score"] = "#{Util.get_score(inn1.score, inn1.for)}"
        end


        hash["inn1"]["color"] = inn1.bat_team.abbrevation
        hash["inn2"] = {}
        hash["inn2"]["teamname"] = inn2.bat_team.get_abb
        hash["inn2"]["won"] = match.winner_id == inn2.bat_team_id
        if match.winner_id == inn2.bat_team_id
            hash["inn2"]["score"] = "⭐️ #{Util.get_score(inn2.score, inn2.for)}"
        else
            hash["inn2"]["score"] = "#{Util.get_score(inn2.score, inn2.for)}"
        end
        hash["inn2"]["color"] = inn2.bat_team.abbrevation

        hash["tour"] = match.get_tour_font
        hash["tour_name"] = "#{Tournament.find(match.tournament_id).name.upcase}"
        hash["venue"] = match.venue.titleize
        hash["m_id"] = m_id
        return hash
    end

    def get_journey_result(squad)
        squad_id = squad.id
        if self.winner_id == squad_id
            if self.win_by_wickets.nil? and self.win_by_runs.nil?
                return "won by Super Over".upcase
            elsif self.win_by_wickets.nil?
                return "won by #{self.win_by_runs} Runs".upcase
            else
                return "won by #{self.win_by_wickets} Wickets".upcase
            end
        else
            if self.win_by_wickets.nil? and self.win_by_runs.nil?
                return "lost by Super Over".upcase
            elsif self.win_by_wickets.nil?
                return "lost by #{self.win_by_runs} Runs".upcase
            else
                return "lost by #{self.win_by_wickets} Wickets".upcase
            end
        end
    end

    def get_highlights_hash
        arr = []
        scores = self.scores.where('runs >= 50')
        scores.each do|score|
            score_type = "50"
            score_ss = 50
            arr << self.get_highlights_hash_score(score, score_ss, score_type)
            if score.runs >= 100
                score_type = "100"
                score_ss = 100
                arr << self.get_highlights_hash_score(score, score_ss, score_type)
            end
        end
        spells = self.spells.where('wickets >= 3')
        spells.each do|spell|
            spell_type = "3W-haul"
            spell_ss = 3
            arr << self.get_highlights_hash_spell(spell, spell_ss, spell_type)
            if spell.wickets >= 5
                spell_type = "5W-haul"
                spell_ss = 5
                arr << self.get_highlights_hash_spell(spell, spell_ss, spell_type)
            end
        end
        arr
    end

    private

    def update_stats
        Uploader.update_bat_stats(self)
        Uploader.update_ball_stats(self)
    end

    def update_tournament
        if self.stage == 'final'
            Uploader.update_tournament_after_final(self)
        end
    end

    def get_highlights_hash_spell(spell, spell_ss, spell_type)
        temp = {}
        team = spell.squad.team
        temp['color'] = team.abbrevation
        p_id = spell.player_id
        tour_class_ids = Tournament.where(name: self.tournament.name).pluck(:id)
        p_spells = Spell.where(player_id: p_id, match_id: 1..self.id, wickets: spell_ss..Float::INFINITY)
        overall_ = p_spells.length
        tour_class_ = p_spells.select { |spell| tour_class_ids.include? spell.tournament_id }.length
        tour_ = p_spells.select { |spell| spell.tournament_id == self.tournament_id }.length
        team_ = p_spells.select { |spell| team.squads.pluck(:id).include? spell.squad_id }.length
        temp['message'] = "#{spell.player.name.titleize}'s' #{Util.ordinal_suffix(tour_class_)} #{spell_type} in #{self.tournament.name}"
        temp['others'] = [
          "#{Util.ordinal_suffix(tour_)} #{spell_type} in this tournament",
          "#{Util.ordinal_suffix(team_)} #{spell_type} for #{team.get_abb}",
          "#{Util.ordinal_suffix(overall_)} #{spell_type} overall"
        ]
        temp
    end

    def get_highlights_hash_score(score, score_ss, score_type)
        temp = {}
        team = score.squad.team
        temp['color'] = team.abbrevation
        p_id = score.player_id
        tour_class_ids = Tournament.where(name: self.tournament.name).pluck(:id)
        p_scores = Score.where(player_id: p_id, match_id: 1..self.id, runs: score_ss..Float::INFINITY)
        overall_ = p_scores.length
        tour_class_ = p_scores.select { |score| tour_class_ids.include? score.tournament_id }.length
        tour_ = p_scores.select { |score| score.tournament_id == self.tournament_id }.length
        team_ = p_scores.select { |score| team.squads.pluck(:id).include? score.squad_id }.length
        temp['message'] = "#{score.player.name.titleize}'s' #{Util.ordinal_suffix(tour_class_)} #{score_type} in #{self.tournament.name}"
        temp['others'] = [
          "#{Util.ordinal_suffix(tour_)} #{score_type} in this tournament",
          "#{Util.ordinal_suffix(team_)} #{score_type} for #{team.get_abb}",
          "#{Util.ordinal_suffix(overall_)} #{score_type} overall"
        ]
        temp
    end
end
