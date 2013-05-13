class ProgressionsController < ApplicationController

  # GET /jobs/progressions
  # GET /jobs/progressions.json
  def index
    @progressions = Progression.by_user(current_user)
    respond_to do |format|
      format.json { render json: @progressions }
    end
  end

  # GET /jobs/progression/:job_id
  # GET /jobs/progression/:job_id.json
  def show_by_job_id
    begin
      @progression = Job.retrieve_progress(params[:job_id])
      respond_to do |format|
        format.json { render json: @progression }
      end
    rescue Exception
      respond_to do |format|
        format.json { render :json => nil, status: 404 }
      end
    end
  end

end
