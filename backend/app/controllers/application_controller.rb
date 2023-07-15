class ApplicationController < ActionController::Base

  def render_404(msg="some error", resp = {})
    resp["error"] = msg
    render :json => resp, :status => 404
  end

  def render_200(msg="Success", resp = {})
    resp["message"] = msg
    render :json => resp, :status => 200
  end
end
