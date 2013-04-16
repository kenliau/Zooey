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

  def status_hash
    {
      status: '',
      stage: '',
      metrics: {
        bytes: 0,
        speed: 0,
        chunk_count: 0,
        output_size: 0,
        output_url: ''
      }
    }
  end

  def percent_complete
    #percent = (self.progression.chunks_tcoded_so_far.to_i / self.video.size) * 100
    #percent > 100 ? 100 : percent
    rand(1..100).to_i
  end

  def self.update_progress(params)
    # Needs to format params
    stage = params[:stage]
    if stage === 'pull'
      case params[:status]
      when 'start'
        puts 'pull start'
      when 'update'
        puts 'pull update'
      when 'finish'
        puts 'pull finish'
      end
    elsif stage == 'chunk'
      case params[:status]
      when 'start'
        puts 'chunk start'
      when 'update'
        puts 'chunk update'
      when 'finish'
        puts 'chunk finish'
      end
    elsif stage == 'transcode'
      case params[:status]
      when 'start'
        puts 'transcode start'
      when 'update'
        puts 'transcode update'
      when 'finish'
        puts 'transcode finish'
      end
    elsif stage == 'merger'
      case params[:status]
      when 'start'
        puts 'merger start'
      when 'update'
        puts 'merger update'
      when 'finish'
        puts 'merger finish'
      end
    else
      puts 'cleanup'

    end
  end

  def self.retrieve_progress(params)
    job = $redis.get(self.redis_key(params[:job_id]))
    if job.nil?
      # NOT FOUND, create a new entry in Redis
      
      #$redis.set(self.redis_key(params[:job_id]),
      #         self.find(params[:job_id]).to_json(:include => [:progression, :video]))
      $redis.set(self.redis_key(params[:job_id]),
                 params)

    end
    job = $redis.get(self.redis_key(params[:job_id]))
  end


  def self.redis_key(job_id)
    "job_progress:#{job_id}"
  end

  scope :by_user, lambda{ |uid| joins(:video).where(:videos => {:user_id => uid} ) }

end
