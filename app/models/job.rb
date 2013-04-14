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
                    body: {id: self.id, video: {size: 300}})
    end
  end

  def percent_complete
    #percent = (self.progression.chunks_tcoded_so_far.to_i / self.video.size) * 100
    #percent > 100 ? 100 : percent
    rand(1..100).to_i
  end

  def self.update_progress(params)
    # Needs to format params
    if (params[:status] === 'start' || params[:status] === 'finish')
      self.save
    end
  end

  def self.retrieve_progress(params)
    job = $redis.get(self.redis_key(params[:job_id]))
    if job.nil?
      
      $redis.set(self.redis_key(params[:job_id]),
               self.find(params[:job_id]).to_json(:include => [:progression, :video]))

    end
    job = $redis.get(self.redis_key(params[:job_id]))
  end


  def self.redis_key(job_id)
    "job_progress:#{job_id}"
  end

  scope :by_user, lambda{ |uid| joins(:video).where(:videos => {:user_id => uid} ) }

end
