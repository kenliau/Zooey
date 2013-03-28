class JobsController < ApplicationController
  # Requires current user to own job or be admin
  before_filter :authenticate_user!, :except => [:job_progression]
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
    @jobs = Job.where_user(current_user)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobs }
    end
  end

  # GET /jobs/progression/:job_id
  def job_progression
    progression = Progression.status_by_job_id(params[:job_id])
    respond_to do |format|
      unless progression.blank?
        format.json { render json: progression }
      else
        format.json { render json: progression, status: 404 }
      end
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
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
