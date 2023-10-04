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

  private

  def filter_params
    params.permit(:tournament_id, :schedule_json)
  end
end