class AdminController < ApplicationController

  before_filter :require_admin

  def require_admin
    # TODO: this is dependent on users existing
    #unless @user and @user.is_admin?
      #flash[:error] = "Only admins can access this page"
      #return redirect_to '/login'
    #end
  end

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
