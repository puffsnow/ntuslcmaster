class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_grades

  private

  def get_grades
    @maximum_grade = Member.maximum('grade')
    @minimum_grade = Member.minimum('grade')
  end

  def render_error_message(message)
    response = Hash.new
    response["success"] = false
    response["message"] = message
    render :json => { response: response }
  end

  def render_success
    response = Hash.new
    response["success"] = true
    render :json => { response: response }
  end

  def authenticate_member
    if current_user.member.nil?
      respond_to do |format|
        format.html { redirect_to "/members/index" }
        format.json { render_error_message "您尚未被認證為社員，不允許進行這項操作" }
      end
      return false
    end
  end
  
end
