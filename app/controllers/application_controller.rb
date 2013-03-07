class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_admin
    unless user_signed_in? and current_user.is_admin
      flash[:error] = "Only admins can access this page"
      return redirect_to '/'
    end
  end
end
