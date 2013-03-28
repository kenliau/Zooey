class VideosController < ApplicationController
  before_filter :authenticate_user!

  # Requires current user to own video or be admin
  def owns_video_or_admin 
  end

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.where(user_id: current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos }
    end
  end

  def new 
    @video = Video.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video }
    end
  end

  # POST /videos
  # POST /videos.json
  def create
    @user = User.find(current_user.id)

    filename = params[:video_file].to_s
    duration = Time.now #temp value
    gop_length = 10 #temp value
    frame_distance = 10 #temp value
    size = 10 #temp value
    
    @video = @user.videos.new({
      filename: filename,
      duration: duration,
      gop_length: gop_length,
      frame_distance: frame_distance,
      size: size
    })

    resolution = params[:output_resolution].to_s
    x_index = resolution.index('x')
    width = resolution[0, x_index]
    height = resolution[x_index+1, resolution.length]

    @job = @video.jobs.new({
      mux_rate: params[:mux_rate],
      width: width,
      height: height,
      h264_profile: params[:h264_profile],
      h264_quality: params[:h264_quality],
      audio_codec: params[:audio_codec],
      audio_bitrate: params[:audio_bitrate],
      audio_volume: params[:audio_volume]
    })

    @progression = @job.create_progression()

    respond_to do |format|
      if @video.save and @job.save  

        format.html { redirect_to @video, notice: 'Video was successfully uploaded.' }
        format.json { render json: @video, status: :created, location: @video }

      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show

    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video }
    end
  end


  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video = Video.find(params[:id])
    # Find, stop and delete all jobs with this video_id
    @jobs = Job.where( video_id: params[:id] )
    
    @video.destroy
    @jobs.destroy_all

    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end

end

