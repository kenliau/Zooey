class Job < ActiveRecord::Base
  has_one :progression
  belongs_to :video
  attr_accessible :audio_bitrate, :audio_codec, :audio_volume, :finished_at, :h264_profile, :h264_quality, :height, :mux_rate, :width, :pull_speed, :pull_bytes, :transcode_speed, :transcode_bytes, :chunks

  validates :audio_bitrate, :audio_codec, :audio_volume, :h264_profile, :h264_quality, :height, :mux_rate, :width,
    :presence => {
      message: "is a required field"
    }

  validates :height, :width, :audio_bitrate, :audio_volume,
    :numericality => {
      :only_integer => true,
      :greater_than_or_equal_to => 1
    }

  validates :mux_rate,
    :numericality => {
      :only_integer => true,
      :less_than_or_equal_to => 25000,
      :greater_than_or_equal_to => 1
    }

  after_create :transcode

  # temporarily this only starts the mock backend
  def transcode
    if Rails.env.production?
      #HTTParty.post('http://safe-fortress-3978.herokuapp.com/transcode',
      binding.pry
      HTTParty.post(ENV['CLUSTER_IP'],
                    body: self.as_json(:include => [:video]))
    elsif Rails.env.development?
      HTTParty.post('http://localhost:4000/transcode',
                    body: self.as_json(:include => [:video]))
    end
  end

  STATUS_HASH =
    {
      pull: {
        bytes: 0,
        speed: 0
      },
      chunk: {
        chunk_count: 0
      },
      transcode: {
        bytes: 0,
        speed: 0
      },
      merger: {
        output_size: 0,
        output_url: ''
      },
      cleanup: {
      }
    }

  def percent_complete
    #percent = (self.progression.chunks_tcoded_so_far.to_i / self.video.size) * 100
    #percent > 100 ? 100 : percent
    rand(1..100).to_i
  end

  def self.update_progress(params)
    # Needs to format params
    jobID = params[:job_id]
    @job = Job.find(jobID)
    status = $redis.get(self.redis_key(jobID))
    status = JSON.parse(status)
    stage = params[:stage]
    if stage === 'pull'
      case params[:status]
      when 'start'
        puts 'pull start'
        @job.progression.pull_start_time = Time.now
        status['pull']['bytes'] = params[:metrics][:bytes]
        status['pull']['speed'] = params[:metrics][:speed]
      when 'update'
        puts 'pull update'
        status['pull']['bytes'] = params[:metrics][:bytes]
        status['pull']['speed'] = params[:metrics][:speed]
      when 'finish'
        puts 'pull finish'
        @job.progression.pull_finish_time = Time.now
        status['pull']['bytes'] = params[:metrics][:bytes]
        status['pull']['speed'] = params[:metrics][:speed]
      end
    elsif stage == 'chunk'
      case params[:status]
      when 'start'
        puts 'chunk start'
        @job.progression.chunker_start_time = Time.now
        status['chunk']['chunk_count'] = params[:metrics][:chunk_count]
      when 'update'
        puts 'chunk update'
        status['chunk']['chunk_count'] = params[:metrics][:chunk_count]
      when 'finish'
        puts 'chunk finish'
        @job.progression.chunker_finish_time = Time.now
        status['chunk']['chunk_count'] = params[:metrics][:chunk_count]
      end
    elsif stage == 'transcode'
      case params[:status]
      when 'start'
        puts 'transcode start'
        @job.progression.tcoder_start_time = Time.now
        status['transcode']['bytes'] = params[:metrics][:bytes]
        status['transcode']['speed'] = params[:metrics][:speed]
      when 'update'
        puts 'transcode update'
        status['transcode']['bytes'] = params[:metrics][:bytes]
        status['transcode']['speed'] = params[:metrics][:speed]
      when 'finish'
        puts 'transcode finish'
        @job.progression.tcoder_finish_time = Time.now
        status['transcode']['bytes'] = params[:metrics][:bytes]
        status['transcode']['speed'] = params[:metrics][:speed]
      end
    elsif stage == 'merger'
      case params[:status]
      when 'start'
        puts 'merger start'
        @job.progression.merger_start_time = Time.now
        status['merger']['output_size'] = params[:metrics][:output_size]
        status['merger']['output_url'] = params[:metrics][:output_url]
      when 'update'
        puts 'merger update'
        status['merger']['output_size'] = params[:metrics][:output_size]
        status['merger']['output_url'] = params[:metrics][:output_url]
      when 'finish'
        puts 'merger finish'
        @job.progression.merger_finish_time = Time.now
         
        @job.output_size = status['merger']['output_size'] = params[:metrics][:output_size]
        @job.output_url = status['merger']['output_url'] = params[:metrics][:output_url]
      end
    else
      puts 'cleanup'
      @job.finished_at = Time.now
      @job.save

    end

    # Assign to REDIS
    status = status.to_json
    $redis.set(self.redis_key(params[:job_id]), status)
    if (params[:status] === 'start' || params[:status] === 'finish')
      @job.progression.save
      @job.save
    end
  end

  def self.retrieve_progress(job_id)
    job = $redis.get(self.redis_key(job_id))
    if job.nil?
      # NOT FOUND, create a new entry in Redis

      #$redis.set(self.redis_key(params[:job_id]),
      #         self.find(params[:job_id]).to_json(:include => [:progression, :video]))
      status = STATUS_HASH.to_json
      $redis.set(self.redis_key(job_id), status)

    end
    job = $redis.get(self.redis_key(job_id))
  end


  def self.redis_key(job_id)
    "job_progress:#{job_id}"
  end

  scope :by_user, lambda{ |uid| joins(:video).where(:videos => {:user_id => uid} ) }

end
