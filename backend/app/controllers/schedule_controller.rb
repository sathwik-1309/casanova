class ScheduleController < ApplicationController

  def upload_file
    uploaded_file = params[:schedule_json]
    if uploaded_file.present?
      # Check the file type if necessary (e.g., to ensure it's JSON)
      if File.extname(uploaded_file.original_filename).downcase == '.json'
        # Save the file or process it as needed
        s_json = JSON.parse(uploaded_file.read)
        begin
          Schedule.create_tournament_schedules(s_json)
          render_200("Schedules created")
        rescue StandardError => ex
          render_202(ex.message)
        end
      else
        render_202("Please upload a json file")
      end
    else
      render_202("Please select a file to upload")
    end
  end

  def squad_schedule
    arr
    squad = Squad.find_by_id(:squad_id)
    games = Schedule.where("squad1_id =? or squad2_id =?", squad.id, squad.id)
    games.each do |schedule|
      temp = schedule.schedule_box
      if temp['squad1']['abbrevation'] != squad.abbrevation
        temp['squad1'], temp['squad2'] = temp['squad2'], temp['squad1']
      end
      arr << temp
    end
    render(:json => Oj.dump(arr))
  end

  def pre_match
    if filter_params[:schedule_id].present?
      schedule = Schedule.find_by_id(filter_params[:schedule_id])
      hash = schedule.pre_match_hash(schedule.squad1.team, schedule.squad2.team, Match.last.id + 1)
    elsif filter_params[:match_id].present?
      schedule = Schedule.find_by(match_id: filter_params[:match_id])
      hash = schedule.pre_match_hash
    else
      hash = Schedule.new.pre_match_hash(Team.find(filter_params[:team1]), Team.find(filter_params[:team2]), Match.last.id+1)
    end
    
    render(:json => Oj.dump(hash))
  end

  def pre_match_squads
    if filter_params[:schedule_id].present?
      schedule = Schedule.find_by_id(filter_params[:schedule_id])
    else
      schedule = Schedule.find_by(match_id: filter_params[:match_id])
    end
    
    hash = schedule.pre_match_squads_hash
    render(:json => Oj.dump(hash))
  end

  private

  def filter_params
    params.permit(:tournament_id, :schedule_json, :squad_id, :schedule_id, :match_id, :team1, :team2)
  end

end