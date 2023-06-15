class Player < ApplicationRecord
    has_many :scores
    has_many :spells
    has_one :bat_stats
    has_one :ball_stats
    has_many :performances
    def country
        return Team.find_by(id: self.country_team_id)
    end

    def tour_individual_awards_to_hash(t_id, award="")
        hash = {}
        hash["name"] = self.fullname.upcase
        hash["p_id"] = self.id
        hash["color"] = Squad.find(Score.find_by(tournament_id: t_id, player_id: self.id).squad_id).abbrevation
        hash["matches"] = Score.where(tournament_id: t_id, player_id: self.id).count
        case award
        when "most_runs"
            runs_array = Score.where(batted: 'true', player_id: self.id, tournament_id: t_id, ).pluck(:runs)
            hash["runs"] = runs_array.sum
        when "most_wickets"
            wickets_array = Spell.where(tournament_id: t_id, player_id: self.id).pluck(:wickets)
            hash["wickets"] = wickets_array.sum
        when "mvp"
            batting_balls = Ball.where(tournament_id: t_id, batsman_id: self.id)
            bowling_balls = Ball.where(tournament_id: t_id, bowler_id: self.id)
        when "pots"
            runs_array = Score.where(batted: 'true', player_id: self.id, tournament_id: t_id, ).pluck(:runs)
            hash["runs"] = runs_array.sum
            wickets_array = Spell.where(tournament_id: t_id, player_id: self.id).pluck(:wickets)
            hash["wickets"] = wickets_array.sum
        end
        hash
    end

    # private
end
