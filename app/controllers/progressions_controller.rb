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
    @progression = Job.retrieve_progress(params[:job_id])
    respond_to do |format|
      unless @progression.blank?
        format.json { render json: @progression }
      else
        format.json { render json: @progression, status: 404 }
      end
    end
  end

end
