class VideosController < ApplicationController
  # Requires current user to own video or be admin
  before_filter :authenticate_user!
  before_filter :load_video, :only => [:show, :destroy]
  before_filter :owns_video_or_admin, :only => [:show, :destroy]

  # Sets instance variable for video and checks if it's blank
  def load_video
    @video = Video.find(params[:id])
    if @video.blank?
      return redirect_to '/videos'
    end
  end

  # Requires current user to own video or be admin
  def owns_video_or_admin 
    unless @video.user == current_user or current_user.is_admin
      return redirect_to '/videos'
    end
  end

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.by_user(current_user)
    @jobs = Job.by_user(current_user)

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

    video_name = params[:video_name]

    video_location = params[:video_location]
    if params[:video]
      uploaded_io = params[:video][:video_file]
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
      end
      filename = uploaded_io.original_filename
      video_location = request.protocol + request.host_with_port + '/uploads/' + filename
    end
    duration = Time.now #temp value
    gop_length = rand(1..20).to_i #temp value
    frame_distance = rand(1..30).to_i #temp value
    size = 100 #temp value
    

    @video = @user.videos.new({
      video_name: video_name,
      filename: filename,
      location: video_location,
      duration: duration,
      gop_length: gop_length,
      frame_distance: frame_distance,
      size: size
    })
    @video.save

    @job = @video.jobs.new({
      mux_rate: params[:mux_rate],
      width: params[:width],
      height: params[:height],
      h264_profile: params[:h264_profile],
      h264_quality: params[:h264_quality],
      audio_codec: params[:audio_codec],
      audio_bitrate: params[:audio_bitrate],
      audio_volume: params[:audio_volume]
    })


    respond_to do |format|
      if @video.save and @job.save  
        @progression = @job.create_progression()

        format.html { redirect_to @job, notice: 'Video was successfully submitted for processing' }
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
    @video.destroy



    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end

end

