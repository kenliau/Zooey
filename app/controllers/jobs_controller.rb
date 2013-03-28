class JobsController < ApplicationController
  before_filter :authenticate_user!, :owns_job_or_admin

  # Requires current user to own job or be admin
  def owns_job_or_admin
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
    respond_to do |format|
      format.json { render json: Progression.status_by_job_id }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

end
