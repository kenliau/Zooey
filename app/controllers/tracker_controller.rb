class TrackerController < ApplicationController
 
  respond_to :json
  before_filter :has_job_id
  before_filter :has_status, only: [:create, :edit]

  # POST /job/status
  def create
    $redis.set(redis_key(params[:id]), params[:status])
    respond_with({}, status: 200)
  end

  # GET /job/status/:id
  def show
    state = $redis.get(redis_key(params[:id]))
    respond_with({state: state}, status: 200)
  end

  # PUT /job/status/:id
  def edit
    $redis.set(redis_key(params[:id]), params[:status])
  end

  # DELETE /job/status/:id
  def destroy
    $redis.del(redis_key(params[:id]))
  end

  private
  
  def redis_key(id)
    "job:#{id}"
  end

  def has_job_id
    unless params.include?(:id)
      respond_with({}, status: 400)
    end
  end
  
  def has_status
    unless params.include?(:status)
      respond_with({}, status: 400)
    end
  end
end
