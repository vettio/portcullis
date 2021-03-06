class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |e|
    Rails.logger.warn "Authorization failure! " +
      "Attempted to #{e.action} a #{e.subject} without permission."
    respond_to do | format |
      format.html { redirect_to root_url, alert: e.message }
      format.json { render json: e.message, status: :forbidden }
      format.js   { render json: e.message, status: :forbidden }
    end
  end

  def after_sign_out_path_for(resource)
    root_url
  end

  def after_sign_in_path_for(resource)
    events_url(scope: :recommended)
  end

  def user_for_paper_trail
    user_signed_in? ? current_user : User.new
  end

  use_vanity :current_user if Settings.toggles.ab == true
  extend Browser::ActionController
end
