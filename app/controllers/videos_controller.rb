class VideosController < ApplicationController
  # Requires current user to own video or be admin
  before_filter :authenticate_user!
  before_filter :load_video, :only => [:show, :destroy]
  before_filter :owns_video_or_admin, :only => [:show, :destroy]
  before_filter :smart_add_url_protocol, :only => [:create]

  # Sets instance variable for video and checks if it's blank
  def load_video
    begin
      @video = Video.find(params[:id])
    rescue Exception
      respond_to do |format|
        format.json { render :json => nil, :status => 404 }
        format.html { redirect_to videos_url }
      end
    end
  end

  # Requires current user to own video or be admin
  def owns_video_or_admin 
    unless @video.user == current_user or current_user.is_admin
      return redirect_to '/videos'
    end
  end

  def smart_add_url_protocol
    video_url = params[:video_location]
    return video_url if video_url.nil?
    unless video_url[/^http:\/\//] || video_url[/^https:\/\//]
      params[:video_location] = 'http://' + video_url
    end
  end

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.by_user(current_user)
    @jobs = Job.by_user(current_user)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos.to_json(:include => [:jobs]) }
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
    filename = File.basename(video_location)
    Rack::Utils.escape(filename)

    #if params[:video]
      #uploaded_io = params[:video][:video_file]
      #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      #  file.write(uploaded_io.read)
      #end
      #filename = uploaded_io.original_filename
      #video_location = request.protocol + request.host_with_port + '/uploads/' + filename
    #end
  
    # Test if URL is reachable and get file size
    require "net/http"
    begin
      Rack::Utils.escape(video_location)
      url = URI.parse(video_location)
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      if res.code == "200"
        size = res.content_length
      else
        video_location = nil
        size = 0
      end
    rescue Exception
      video_location = nil
      size = 0
    end

    duration = 0

    @video = @user.videos.new({
      video_name: video_name,
      filename: filename,
      location: video_location,
      duration: duration,
      size: size
    })
    @video.save

    @job = @video.jobs.new({
      video_mux_rate: params[:output_mux_rate],
      width: params[:output_width],
      height: params[:output_height],
      h264_profile: params[:output_h264_profile],
      h264_quality: params[:output_h264_quality],
      gop_length:  params[:output_gop_length],
      frame_distance: params[:output_frame_distance],
      audio_codec: params[:output_audio_codec],
      audio_bitrate: params[:output_audio_bitrate],
      audio_volume: params[:output_audio_volume]
    })


    respond_to do |format|
      if @video.save and @job.save and @job.transcode
        @progression = @job.create_progression()
        format.html { redirect_to @job, notice: 'Video was successfully submitted for processing' }
        format.json { render json: @video, status: :created, location: @video }
      else
        @video.destroy
        format.html { render action: "new" }
        format.json { render :json => {
                                :video_errors => @video.errors, 
                                :job_errors => @job.errors,
                              }, 
                              status: :unprocessable_entity }
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

  def destroy_multiple
    unless !params[:selected_videos]
      Video.destroy(params[:selected_videos])
    end
    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end

end

