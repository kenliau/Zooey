class ProgressionsController < ApplicationController

  # GET /jobs/progression/:job_id
  def show_by_job_id
    @progression = Progression.status_by_job_id(params[:job_id])
    respond_to do |format|
      unless @progression.blank?
        format.json { render json: @progression }
      else
        format.json { render json: @progression, status: 404 }
      end
    end
  end

  # PUT /jobs/progression/:job_id
  def update_by_job_id
    @progression = Progression.where('job_id' => params[:job_id])
    @progression.update_attributes(params[:progression])
  end

end
