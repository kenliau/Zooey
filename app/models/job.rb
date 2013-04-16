class Job < ActiveRecord::Base
  has_one :progression
  belongs_to :video
  attr_accessible :audio_bitrate, :audio_codec, :audio_volume, :finished_at, :h264_profile, :h264_quality, :height, :mux_rate, :width, :pull_speed, :pull_bytes, :transcode_speed, :transcode_bytes, :chunks

  validates :audio_bitrate, :audio_codec, :audio_volume, :h264_profile, :h264_quality, :height, :mux_rate, :width,
    :presence => {
      message: "is a required field"
    }

  validates :height, :width, :audio_bitrate, :audio_volume, :mux_rate,
    :numericality => {
      :only_integer => true,
      :greater_than_or_equal_to => 0
    }

  after_create :transcode

  # temporarily this only starts the mock backend
  def transcode
    if Rails.env.production?
      HTTParty.post('http://safe-fortress-3978.herokuapp.com/transcode',
                    body: self.to_json(:include => [:video]))
    elsif Rails.env.development?
      HTTParty.post('http://localhost:4000/transcode',
                    #body: self.to_json(:include => [:video]))
                    body: {id: self.id, video: {size: 100}})
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
    status = $redis.get(self.redis_key(params[:job_id]))
    status = JSON.parse(status)
    stage = params[:stage]
    if stage === 'pull'
      case params[:status]
      when 'start'
        puts 'pull start'
        # set pull_start_time in DB
        status['pull']['bytes'] = params[:metrics][:bytes]
        status['pull']['speed'] = params[:metrics][:speed]
      when 'update'
        puts 'pull update'
        status['pull']['bytes'] = params[:metrics][:bytes]
        status['pull']['speed'] = params[:metrics][:speed]
      when 'finish'
        puts 'pull finish'
        # set pull_finish_time in DB
        status['pull']['bytes'] = params[:metrics][:bytes]
        status['pull']['speed'] = params[:metrics][:speed]
      end
    elsif stage == 'chunk'
      case params[:status]
      when 'start'
        puts 'chunk start'
        # set chunk_start_time in DB
        status['chunk']['chunk_count'] = params[:metrics][:chunk_count]
      when 'update'
        puts 'chunk update'
        status['chunk']['chunk_count'] = params[:metrics][:chunk_count]
      when 'finish'
        puts 'chunk finish'
        # set chunk_finish_time in DB
        status['chunk']['chunk_count'] = params[:metrics][:chunk_count]
      end
    elsif stage == 'transcode'
      case params[:status]
      when 'start'
        puts 'transcode start'
        # set transcode_start_time in DB
        status['transcode']['bytes'] = params[:metrics][:bytes]
        status['transcode']['speed'] = params[:metrics][:speed]
      when 'update'
        puts 'transcode update'
        status['transcode']['bytes'] = params[:metrics][:bytes]
        status['transcode']['speed'] = params[:metrics][:speed]
      when 'finish'
        puts 'transcode finish'
        # set transcode_finish_time in DB
        status['transcode']['bytes'] = params[:metrics][:bytes]
        status['transcode']['speed'] = params[:metrics][:speed]
      end
    elsif stage == 'merger'
      case params[:status]
      when 'start'
        puts 'merger start'
        # set merger_start_time in DB
        status['merger']['output_size'] = params[:metrics][:output_size]
        status['merger']['output_url'] = params[:metrics][:output_url]
      when 'update'
        puts 'merger update'
        status['merger']['output_size'] = params[:metrics][:output_size]
        status['merger']['output_url'] = params[:metrics][:output_url]
      when 'finish'
        puts 'merger finish'
        # set merger_finish_time in DB
        status['merger']['output_size'] = params[:metrics][:output_size]
        status['merger']['output_url'] = params[:metrics][:output_url]
      end
    else
      puts 'cleanup'

    end

    # Assign to REDIS
    status = status.to_json
    $redis.set(self.redis_key(params[:job_id]), status)

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
