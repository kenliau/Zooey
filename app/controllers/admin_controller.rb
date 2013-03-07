class AdminController < ApplicationController

  before_filter :require_admin

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def users
    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def videos
    respond_to do |format|
      format.html
      format.json { render json: @documentation }
    end
  end

  def jobs
    respond_to do |format|
      format.html
      format.json { render json: @documentation }
    end
  end

end
