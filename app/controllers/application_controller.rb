class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :show_me_params

  def show_me_params
  	Rails.logger.info "___________________current_user____________#{current_user.inspect}"
  end
end
