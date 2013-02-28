class AdminController < ApplicationController

  before_filter :require_admin

  def require_admin
    unless user_signed_in? and current_user.is_admin?
      flash[:error] = "Only admins can access this page"
      return redirect_to '/login'
    end
  end

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def users
  end

  def videos
  end

  def jobs
  end

end
