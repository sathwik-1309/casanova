# require_relative "#{Dir.pwd}/config/environment"
# require "#{Dir.pwd}/lib/util"

class Ingest
    attr_accessor :m_id, :inn_id, :o_id, :b_id, :wicket_id, :args, :inn_no, :bat_team_id, :bow_team_id, :batsmen, :b1, :b2, :sr, :score, :for, :overs, :scores_hash, :over_no, :current_bowler, :ball_color, :inn_csv, :overs_csv, :balls_csv, :wickets_csv, :scores_csv, :score_id, :spells, :ingest_json, :inn_extras, :status, :spells_csv, :spell_id, :part_csv, :part, :part_id

    def initialize(args)
        self.status = false
        self.m_id = Match.last.id
        self.inn_id = Inning.last.id
        self.o_id = Over.last.id
        self.b_id = Ball.last.id
        self.wicket_id = Wicket.last.id
        self.score_id = Score.last.id
        self.spell_id = Spell.last.id
        self.part_id = Partnership.last.id
        self.inn_csv = []
        self.overs_csv = []
        self.balls_csv = []
        self.wickets_csv = []
        self.scores_csv = []
        self.spells_csv = []
        self.part_csv = []
        self.args = args
        self.inn_no = 0
        self.ingest_json = {}

        Ingest::Match_.new(self)

        File.open(MATCH_INGEST_JSON_PATH, 'w') do |file|
            file.write(JSON.pretty_generate(self.ingest_json))
        end
        puts "Ingest# #{self.m_id} generated ✅"
        self.status = true
    end

    def self.format_spells(spells)
        spells_array = []
        spells.keys().each do |id|
            spells_array << {
                "bowler": id,
                "overs": Util.balls_to_overs(spells[id]["balls"]),
                "runs": spells[id]["runs"],
                "wickets": spells[id]["wickets"]
            }
        end
        return spells_array
    end

    def change_strike
        if self.b1["id"] == self.sr
            self.sr = self.b2["id"]
        else
            self.sr = self.b1["id"]
        end
    end

    def self.create_csv(header, rows, filename)
        CSV.open(MATCH_CSV_PATH + "/#{filename}.csv", "w") do |csv|
            csv << header
            rows.each do|row|
                csv << row
            end
        end
    end

    def set_part_config(position)
        hash = {}
        hash["b1"] = self.b1["id"]
        hash["b1s"] = 0
        hash["b1b"] = 0
        hash["b2"] = self.b2["id"]
        hash["b2s"] = 0
        hash["b2b"] = 0
        hash["for_wicket"] = position
        hash["runs"] = 0
        hash["balls"] = 0
        hash["c0"] = 0
        hash["c1"] = 0
        hash["c2"] = 0
        hash["c3"] = 0
        hash["c4"] = 0
        hash["c6"] = 0
        return hash
    end

    def self.set_batsman_config(batsman, team_id, position=false, not_out=false)
        hash = {}
        hash["id"] = Util.get_pid_team(batsman["name"], team_id)
        if position
            hash["batted"] = true
            hash["pos"] = position
            hash["runs"] = 0
            hash["balls"] = 0
            hash["c0"] = 0
            hash["c1"] = 0
            hash["c2"] = 0
            hash["c3"] = 0
            hash["c4"] = 0
            hash["c6"] = 0
            hash["method"] = batsman["method"]
            hash["fielder"] = batsman["fielder"]
            hash["bowler"] = nil
        else
            hash["batted"] = false
        end
        if not_out
            hash["not_out"] = true
        end
        return hash
    end

    def self.get_ball_category(runs)
        if runs == 0
            cat = "c0"
        elsif runs == 1
            cat = "c1"
        elsif runs == 2
            cat = "c2"
        elsif runs == 3
            cat = "c3"
        elsif runs == 4
            cat = "c4"
        elsif runs == 6
            cat = "c6"
        else
            puts "Ingest#get_ball_category: runs not found #{runs}"
        end
        return cat
    end

    def add_batsman_runs(sr, b1, b2, runs)
        cat = Ingest.get_ball_category(runs)
        if self.b1["id"]== self.sr
            self.b1["runs"] += runs
            self.b1["balls"] += 1
            self.b1[cat] += 1
        else
            self.b2["runs"] += runs
            self.b2["balls"] += 1
            self.b2[cat] += 1
        end
        if (runs.to_i)%2==1
            self.change_strike
        end
    end

    def update_part(runs, extras=0, extra_type=nil)
        if extra_type != 'wd'
            self.part["balls"] += 1
            cat = Ingest.get_ball_category(runs)
            self.part[cat] += 1
        end
        if self.sr == self.b1["id"]
            self.part["b1s"] += runs
            self.part["b1b"] += 1
        else
            self.part["b2s"] += runs
            self.part["b2b"] += 1
        end

        self.part["runs"] += runs + extras
    end

    def get_performances
        performances = []
        self.scores_csv.each do|score|
            temp = []
            temp << score[0]
            p_id = score[12]
            squad_id = score[13]
            inn_id = score[14]
            m_id = score[15]
            t_id = score[16]
            squad = Squad.find_by(abbrevation: self.args["winner"], tournament_id: self.args["t_id"])
            if squad.id == squad_id
                temp << true
            else
                temp << false
            end
            if inn_id%2==1
                squad = Squad.find_by(abbrevation: self.args["batted_first"], tournament_id: self.args["t_id"])
                if p_id == Util.get_pid_team(self.args["cap1"], squad.team_id)
                    temp << true
                else
                    temp << false
                end
                if p_id == Util.get_pid_team(self.args["keeper1"], squad.team_id)
                    temp << true
                else
                    temp << false
                end
            else
                squad = Squad.find_by(abbrevation: self.args["batted_second"], tournament_id: self.args["t_id"])
                if p_id == Util.get_pid_team(self.args["cap2"], squad.team_id)
                    temp << true
                else
                    temp << false
                end
                if p_id == Util.get_pid_team(self.args["keeper2"], squad.team_id)
                    temp << true
                else
                    temp << false
                end
            end
            temp << m_id
            temp << t_id
            temp << p_id
            temp << squad_id
            performances << temp
        end
        return performances
    end

    class Match_
        def initialize(parent)
            @parent = parent
            @parent.m_id += 1

            self.create_hash

            file = File.read(MATCH_JSON_PATH)
            data = JSON.parse(file)
            inn1 = Ingest::Innings_.new(@parent, data["inn1"])
            inn2 = Ingest::Innings_.new(@parent, data["inn2"])

            header = ["id", "inn_no", "overs", "score", "for", "ball_color1", "ball_color2", "m_id", "t_id", "bat_team_id", "bow_team_id" ]
            Ingest.create_csv(header, @parent.inn_csv, "innings")

            header = ["id", "over_no", "score", "for", "ball_color", "bowler_id", "inn_id", "m_id", "t_id"]
            Ingest.create_csv(header, @parent.overs_csv, "overs")

            header = ["id", "runs", "extras", "extra_type", "delivery", "wicket_ball", "score", "for", "category", "bow_runs", "ball_color", "batsman_id", "bowler_id", "o_id", "inn_id", "m_id", "t_id"]
            Ingest.create_csv(header, @parent.balls_csv, "balls")

            header = ["id", "method", "b_id", "o_id", "inn_id", "m_id", "t_id", "batsman_id", "bowler_id", "fielder_id", "delivery"]
            Ingest.create_csv(header, @parent.wickets_csv, "wickets")

            header = ["id", "runs", "balls", "position", "not_out", "batted", "c0", "c1", "c2", "c3", "c4", "c6", "player_id", "squad_id", "inning_id", "match_id", "tournament_id"]
            Ingest.create_csv(header, @parent.scores_csv, "scores")

            header = ["id", "won", "captain", "keeper", "match_id", "tournament_id", "player_id", "squad_id"]
            performances = @parent.get_performances
            Ingest.create_csv(header, performances, "performances")

            header = ["id", "overs", "runs", "wickets", "player_id", "squad_id", "inning_id", "match_id", "tournament_id"]
            Ingest.create_csv(header, @parent.spells_csv, "spells")

            header = ["id", "runs", "balls", "c0", "c1", "c2", "c3", "c4", "c6", "for_wicket", "not_out", "b1s", "b2s", "b1b", "b2b", "inn_id", "m_id", "t_id", "b1", "b2", "bat_team_id", "bow_team_id" ]
            Ingest.create_csv(header, @parent.part_csv, "partnerships")



        end

        def create_hash
            if @parent.args["winner"] == @parent.args["batted_first"]
                loser = @parent.args["batted_second"]
            else
                loser = @parent.args["batted_first"]
            end
            winner_id = Squad.find_by(abbrevation: @parent.args["winner"], tournament_id: @parent.args["t_id"]).id
            loser_id = Squad.find_by(abbrevation: loser, tournament_id: @parent.args["t_id"]).id
            motm_id = Util.get_pid_team(@parent.args["motm_player"], Team.find_by(abbrevation: @parent.args["motm_team"]).id)
            toss_id = Squad.find_by(abbrevation: @parent.args["toss"], tournament_id: @parent.args["t_id"]).id

            header = ["id", "stage", "venue", "ball_color1", "ball_color2", "pitch", "t_id", "inn1_id", "inn2_id", "winner_id", "loser_id", "motm_id", "toss_id" ]
            match_csv = [[@parent.m_id, @parent.args["stage"], @parent.args["venue"], @parent.args["ball_color"][0], @parent.args["ball_color"][1], @parent.args["pitch"], @parent.args["t_id"], @parent.inn_id + 1, @parent.inn_id + 2, winner_id, loser_id, motm_id, toss_id ]]
            Ingest.create_csv(header, match_csv, "match")
        end

    end

    class Innings_
        def initialize(parent, inn)
            @parent = parent
            @inn = inn
            @parent.inn_id += 1
            @parent.inn_no += 1
            @parent.part_id += 1
            @parent.batsmen = inn["batting"]
            @parent.score = 0
            @parent.for = 0
            @parent.over_no = 0
            @parent.scores_hash = []
            @parent.ingest_json["inn#{@parent.inn_no}"] = {}
            @parent.spells = {}
            @parent.inn_extras = {
                "total_extras"=> 0,
                "wides"=>  0,
                "no_balls"=>  0,
                "lbs"=>  0,
                "byes"=>  0
              }

            self.create_hash

            @parent.scores_hash.each do|score|
                @parent.score_id += 1
                score_csv = [ @parent.score_id, score["runs"], score["balls"], score["pos"], score["not_out"], score["batted"], score["c0"],score["c1"],score["c2"],score["c3"],score["c4"],score["c6"],score["id"],@parent.bat_team_id,@parent.inn_id,@parent.m_id,@parent.args["t_id"]]
                @parent.scores_csv << score_csv
            end

            @parent.part_csv << [ @parent.part_id, @parent.part["runs"], @parent.part["balls"], @parent.part["c0"], @parent.part["c1"], @parent.part["c2"], @parent.part["c3"], @parent.part["c4"], @parent.part["c6"], @parent.part["for_wicket"], true, @parent.part["b1s"], @parent.part["b2s"], @parent.part["b1b"], @parent.part["b2b"], @parent.inn_id, @parent.m_id, @parent.args["t_id"], @parent.part["b1"], @parent.part["b2"], @parent.bat_team_id, @parent.bow_team_id ]

            @parent.spells.keys().each do|bowler|
                @parent.spell_id += 1
                spell_csv = [ @parent.spell_id, Util.balls_to_overs(@parent.spells[bowler]["balls"]), @parent.spells[bowler]["runs"], @parent.spells[bowler]["wickets"], bowler, @parent.bow_team_id, @parent.inn_id, @parent.m_id, @parent.args["t_id"] ]
                @parent.spells_csv << spell_csv
            end
            # ["id", "overs" ,"runs", "wickets", "player_id", "squad_id", "inning_id", "match_id", "tournament_id"]

            @parent.ingest_json["inn#{@parent.inn_no}"]["score"] = @parent.score
            @parent.ingest_json["inn#{@parent.inn_no}"]["for"] = @parent.for
            if @parent.overs.to_s.split(".")[1] == "6"
                @parent.ingest_json["inn#{@parent.inn_no}"]["overs"] = @parent.over_no.to_f
            else
                @parent.ingest_json["inn#{@parent.inn_no}"]["overs"] = @parent.overs
            end
            @parent.ingest_json["inn#{@parent.inn_no}"]["extras"] = @parent.inn_extras
            @parent.ingest_json["inn#{@parent.inn_no}"]["batting"] = @parent.scores_hash
            spells_array = Ingest.format_spells(@parent.spells)
            @parent.ingest_json["inn#{@parent.inn_no}"]["spells"] = spells_array

        end

        def create_hash
            if @parent.inn_no == 1
                bat_team = Squad.find_by(abbrevation: @parent.args["batted_first"], tournament_id: @parent.args["t_id"]).id
                bow_team = Squad.find_by(abbrevation: @parent.args["batted_second"], tournament_id: @parent.args["t_id"]).id
                @parent.bat_team_id = bat_team
                @parent.bow_team_id = bow_team
                ball_color1 = @parent.args["ball_color"][0]
                ball_color2 = @parent.args["ball_color"][1]
            else
                @parent.bat_team_id, @parent.bow_team_id = @parent.bow_team_id, @parent.bat_team_id
                ball_color1 = @parent.args["ball_color"][2]
                ball_color2 = @parent.args["ball_color"][3]
            end
            overs = @inn["bowling"]
            @parent.b1 = Ingest.set_batsman_config(@parent.batsmen[0], Squad.find(@parent.bat_team_id).team_id, 1)
            @parent.b2 = Ingest.set_batsman_config(@parent.batsmen[1], Squad.find(@parent.bat_team_id).team_id, 2)
            @parent.sr = @parent.b2["id"]
            @parent.part = @parent.set_part_config(1)
            overs.each do |over|
                Ingest::Over_.new(@parent, over)
            end
            if @parent.overs == 19.6
                @parent.overs = 20
            end

            @parent.b1["not_out"] = true unless @parent.b1["not_out"] == false
            @parent.b2["not_out"] = true unless @parent.b2["not_out"] == false
            @parent.scores_hash << @parent.b1
            @parent.scores_hash << @parent.b2
            @parent.scores_hash = @parent.scores_hash.sort_by { |hash| hash["pos"] }
            l = @parent.scores_hash.length
            if l > 11
                @parent.scores_hash.pop
                l = @parent.scores_hash.length
            end
            while l < 11
                @parent.scores_hash << Ingest.set_batsman_config(@parent.batsmen[l], Squad.find(@parent.bat_team_id).team_id, false)
                l += 1
            end
            inn_csv = [@parent.inn_id, @parent.inn_no, @parent.overs, @parent.score, @parent.for, ball_color1, ball_color2, @parent.m_id, @parent.args["t_id"], @parent.bat_team_id, @parent.bow_team_id]
            @parent.inn_csv << inn_csv
        end

    end

    class Over_
        def initialize(parent, over)
            @parent = parent
            @over = over
            @parent.o_id += 1
            @parent.over_no += 1
            @parent.overs = (@parent.over_no - 1).to_f.round(1)
            @parent.current_bowler = Util.get_pid_team(over["bowler"], Squad.find(@parent.bow_team_id).team_id)
            if @parent.inn_no == 1
                if @parent.over_no%2==0
                    @parent.ball_color = @parent.args["ball_color"][1]
                else
                    @parent.ball_color = @parent.args["ball_color"][0]
                end
            else
                if @parent.over_no%2==0
                    @parent.ball_color = @parent.args["ball_color"][3]
                else
                    @parent.ball_color = @parent.args["ball_color"][2]
                end

            end
            @parent.change_strike

            self.create_hash
        end

        def create_hash
            @over["sequence"].each do |ball|
                Ingest::Ball_.new(@parent, ball)
            end

            over_csv = [@parent.o_id, @parent.over_no, @parent.score, @parent.for, @parent.ball_color, @parent.current_bowler, @parent.inn_id, @parent.m_id, @parent.args["t_id"]]
            @parent.overs_csv << over_csv
        end
    end

    class Ball_
        def initialize(parent, ball)
            @parent = parent
            @parent.b_id += 1
            @ball = ball
            self.create_hash
        end

        def create_hash
            category = NILL
            runs = 0
            extras = 0
            bow_runs = 0
            extra_type = NILL
            wicket_ball = false
            bow_runs = 0
            if @parent.spells.keys().exclude? @parent.current_bowler
                @parent.spells[@parent.current_bowler] = {
                    "runs"=> 0,
                    "balls"=> 0,
                    "wickets"=> 0
                }
            end
            if @ball.length == 1
                @parent.overs += 0.1
                @parent.overs = @parent.overs.round(1)
                if @ball=='W'
                    category = "c0"
                    wicket_ball = true
                    @parent.spells[@parent.current_bowler]["balls"] += 1
                    @parent.spells[@parent.current_bowler]["wickets"] += 1
                    @parent.update_part(0)
                else
                    runs = @ball.to_i
                    bow_runs = runs
                    category = Ingest.get_ball_category(runs)
                    @parent.add_batsman_runs(@parent.sr, @parent.b1, @parent.b2, runs)
                    @parent.spells[@parent.current_bowler]["runs"] += runs
                    @parent.spells[@parent.current_bowler]["balls"] += 1
                    @parent.update_part(runs)
                end
            else
                e_runs = @ball[0].to_i
                extra_type = @ball[1..]
                if extra_type == 'nb'
                    extras = 1
                    extra_type = 'nb'
                    runs = e_runs
                    bow_runs = e_runs + extras
                    category = Ingest.get_ball_category(runs)
                    @parent.add_batsman_runs(@parent.sr, @parent.b1, @parent.b2, runs.to_i)
                    @parent.spells[@parent.current_bowler]["runs"] += runs + extras
                    @parent.inn_extras["total_extras"] += extras
                    @parent.inn_extras["no_balls"] += extras
                elsif extra_type=='wd'
                    extras = 1 + e_runs
                    bow_runs = extras
                    extra_type = 'wd'
                    @parent.spells[@parent.current_bowler]["runs"] +=  extras
                    @parent.inn_extras["total_extras"] += extras
                    @parent.inn_extras["wides"] += extras
                elsif extra_type=='lb'
                    extras = e_runs
                    extra_type = 'lb'
                    @parent.overs += 0.1
                    @parent.overs = @parent.overs.round(1)
                    @parent.add_batsman_runs(@parent.sr, @parent.b1, @parent.b2, 0)
                    @parent.spells[@parent.current_bowler]["balls"] += 1
                    @parent.inn_extras["total_extras"] += extras
                    @parent.inn_extras["lbs"] += extras
                    if e_runs%2==1
                        @parent.change_strike
                    end
                elsif extra_type == 'b'
                    extras = e_runs
                    extra_type = 'b'
                    @parent.overs += 0.1
                    @parent.overs = @parent.overs.round(1)
                    @parent.add_batsman_runs(@parent.sr, @parent.b1, @parent.b2, 0)
                    @parent.spells[@parent.current_bowler]["balls"] += 1
                    @parent.inn_extras["total_extras"] += extras
                    @parent.inn_extras["byes"] += extras
                    if e_runs%2==1
                        @parent.change_strike
                    end
                else
                    puts "!!!*!**!*!*!*!*!* NEW EXTRA TYPE #{extra_type}!#&@°&!#‡€!*‹°€"
                end
                @parent.update_part(runs, extras, extra_type)
            end
            @parent.score += runs + extras
            @parent.for += 1 if wicket_ball
            ball_csv = [@parent.b_id, runs, extras, extra_type, @parent.overs, wicket_ball, @parent.score, @parent.for, category, bow_runs, @parent.ball_color, @parent.sr, @parent.current_bowler, @parent.o_id, @parent.inn_id, @parent.m_id, @parent.args["t_id"] ]
            @parent.balls_csv << ball_csv
            Ingest::Wicket_.new(@parent) if wicket_ball
        end

    end

    class Wicket_
        def initialize(parent)
            @parent = parent
            if @parent.sr == @parent.b1["id"]
                @batsman_out = @parent.b1
            else
                @batsman_out = @parent.b2
            end
            @batsman_out["balls"] += 1
            @batsman_out["c0"] += 1
            @batsman_out["not_out"] = false
            @batsman_out["bowler"] = @parent.current_bowler
            @parent.scores_hash << @batsman_out
            @parent.wicket_id += 1
            self.create_hash
        end

        # t.string :method
        # t.belongs_to :ball, foreign_key: true
        # t.belongs_to :over, foreign_key: true
        # t.belongs_to :inning, foreign_key: true
        # t.belongs_to :match, foreign_key: true
        # t.belongs_to :tournament, foreign_key: true
        # t.integer :batsman_id
        # t.integer :bowler_id
        # t.integer :fielder_id
        def create_hash
            if @batsman_out["id"] == @parent.b1["id"]
                @parent.b1 = Ingest.set_batsman_config(@parent.batsmen[@parent.for+1], Squad.find(@parent.bat_team_id).team_id, @parent.for+2) unless @parent.for == 10
                @parent.sr = @parent.b1["id"]
            else
                @parent.b2 = Ingest.set_batsman_config(@parent.batsmen[@parent.for+1], Squad.find(@parent.bat_team_id).team_id, @parent.for+2) unless @parent.for == 10
                @parent.sr = @parent.b2["id"]
            end

            @parent.part_csv << [@parent.part_id, @parent.part["runs"], @parent.part["balls"], @parent.part["c0"], @parent.part["c1"], @parent.part["c2"], @parent.part["c3"], @parent.part["c4"], @parent.part["c6"], @parent.part["for_wicket"], false, @parent.part["b1s"], @parent.part["b2s"], @parent.part["b1b"], @parent.part["b2b"], @parent.inn_id, @parent.m_id, @parent.args["t_id"], @parent.part["b1"], @parent.part["b2"], @parent.bat_team_id, @parent.bow_team_id ]
            @parent.part = @parent.set_part_config(@parent.for+1)
            @parent.part_id += 1

            wicket_csv = [@parent.wicket_id, @batsman_out["method"], @parent.b_id, @parent.o_id, @parent.inn_id, @parent.m_id, @parent.args["t_id"], @batsman_out["id"], @parent.current_bowler, Util.get_pid_team(@batsman_out["fielder"], Squad.find(@parent.bow_team_id).team_id), @parent.overs]
            @parent.wickets_csv << wicket_csv
        end
    end

end

