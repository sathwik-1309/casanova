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
    arr = []
    squad = Squad.find_by_id(filter_params[:squad_id])
    games = Schedule.where("squad1_id = ? or squad2_id =?", squad.id, squad.id)
    games.each do |schedule|
      temp = schedule.schedule_box
      if temp['squad1']['abbrevation'] != squad.abbrevation
        temp['squad1'], temp['squad2'] = temp['squad2'], temp['squad1']
      end
      arr << temp
    end
    render(:json => Oj.dump(arr))
  end

  private

  def filter_params
    params.permit(:tournament_id, :schedule_json, :squad_id)
  end
end