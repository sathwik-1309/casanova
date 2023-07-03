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

    private

    def update_stats
        Uploader.update_bat_stats(self.id)
        Uploader.update_ball_stats(self.id)
    end
end
