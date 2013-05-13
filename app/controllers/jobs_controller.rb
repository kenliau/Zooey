class JobsController < ApplicationController
  # Requires current user to own job or be admin
  before_filter :authenticate_user!, :except => [:update_progress]
  before_filter :load_job, :only => [:show, :destroy]
  before_filter :owns_job_or_admin, :only => [:show, :destroy]

  # Sets instance variable for job and checks if it's blank
  def load_job
    begin
      @job = Job.includes(:progression, :video).find(params[:id])
    rescue Exception
      respond_to do |format|
        format.json { render :json => nil, :status => 404 }
        format.html { redirect_to jobs_url }
      end
    end
  end

  # Requires current user to own job or be admin
  def owns_job_or_admin
    unless @job.video.user == current_user or current_user.is_admin
      respond_to do |format|
        format.json { render :json => nil, :status => :unauthorized }
        format.html { redirect_to jobs_url }
      end
    end
  end

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.by_user(current_user)
    @jobs.each { |job|
      @status = Job.retrieve_progress(job.id)
      job['status'] = JSON.parse(@status)
    }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @jobs.to_json(:include => [:video, :progression]) }
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @status = Job.retrieve_progress(@job.id)
    @job['status'] = JSON.parse(@status)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job.to_json(:include => [:progression, :video]) }
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    if !@job.finished_at?
      @job.destroy
      respond_to do |format|
        format.html { redirect_to jobs_url }
        format.json { head :no_content  }
      end
    else
      respond_to do |format|
        format.html { redirect_to jobs_url }
        format.json { render :json => nil, :status => :unauthorized  }
      end
    end
  end

  def destroy_multiple
    @list = params[:selected_jobs]
    unless !@list
      @list.each do |j|
        @j = Job.find(j)
        if !@j.finished_at?
          @j.destroy
        end
      end
    end
    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end

  # PUT /jobs/:job_id/progression
  def update_progress
    @job = Job.retrieve_progress(params[:job_id])
    Rails.logger.debug("$$$$$$$$$$$$$$$$ PARAMS FROM CLUSTER $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
    Rails.logger.debug(params)
    Job.update_progress(params)

    respond_to do |format|
      format.html {render :nothing => true}
      format.json {render :nothing => true}
    end
  end

end
