class JobsController < ApplicationController
  # Requires current user to own job or be admin
  before_filter :authenticate_user!
  before_filter :load_job, :only => [:show, :destroy]
  before_filter :owns_job_or_admin, :only => [:show, :destroy]

  # Sets instance variable for job and checks if it's blank
  def load_job
    @job = Job.includes(:progression).find(params[:id])
    if @job.blank?
      return redirect_to '/jobs'
    end
  end

  # Requires current user to own job or be admin
  def owns_job_or_admin
    unless @job.video.user == current_user or current_user.is_admin
      return redirect_to '/jobs'
    end
  end

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.by_user(current_user)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobs }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job.to_json(:include => [:progression, :video]) }
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

end
