class Squad < ApplicationRecord
    belongs_to :tournament
    belongs_to :team
    has_many :performances
    has_many :scores
    has_many :spells

    def keeper
        return Player.find(self.keeper_id)
    end
    def captain
        return Player.find(self.captain_id)
    end
    def get_players
        player_ids = Performance.where(squad_id: self.id).pluck(:player_id)
        return Player.where(id: player_ids|[])
    end
    def players
        player_ids = SquadPlayer.where(squad_id: self.id).pluck(:player_id)
        return Player.where(id: player_ids)
    end
    def matches_list
        match_ids = Match.where(winner_id: self.id).pluck(:id)
        match_ids += Match.where(loser_id: self.id).pluck(:id)
        return Match.where(id: match_ids)
    end
    def get_nrr
        match_ids = Match.where(winner_id: self.id, stage: ['league', 'group']).pluck(:id)
        match_ids += Match.where(loser_id: self.id, stage: ['league', 'group']).pluck(:id)
        if match_ids == []
            return 0.0
        end
        runs_list = []
        overs_list = []
        runs_conceded_list = []
        overs_bowled_list = []
        match_ids.each do|match|
            bat_innings = Inning.find_by(match_id: match.to_i, bat_team_id: self.id)
            runs = bat_innings.score
            wickets = bat_innings.for
            if wickets == 10
                overs = 20.0
            else
                overs = bat_innings.overs
            end
            runs_list.append(runs)
            overs_list.append(overs)

            ball_innings = Inning.find_by(match_id: match.to_i, bow_team_id: self.id)
            runs_conceded = ball_innings.score
            wickets_taken = ball_innings.for
            if wickets_taken == 10
                overs_bowled = 20.0
            else
                overs_bowled = ball_innings.overs
            end
            runs_conceded_list.append(runs_conceded)
            overs_bowled_list.append(overs_bowled)
        end
        nrr = ((runs_list.sum.to_f / overs_list.sum.to_f) - (runs_conceded_list.sum.to_f / overs_bowled_list.sum.to_f)).round(2)
        return nrr
    end

    def get_teamname
        return "#{Util.get_flag(self.team_id)} #{self.name.upcase}"
    end

    def get_abb
        return "#{Util.get_flag(self.team_id)} #{self.abbrevation.upcase}"
    end
end
