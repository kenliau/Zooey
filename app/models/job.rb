class Job < ActiveRecord::Base
  has_one :progression
  belongs_to :video
  attr_accessible :audio_bitrate, :audio_codec, :audio_volume, :finished_at, :h264_profile, :h264_quality, :height, :mux_rate, :width

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
      HTTParty.post('http://safe-fortress-3978.herokuapp.com/transcode', body: {id: self.id})
    elsif Rails.env.development?
      HTTParty.post('http://localhost:4000/transcode', body: {id: self.id})
    end
  end

  def percent_complete
    percent = (self.progression.chunks_tcoded_so_far.to_i / self.video.size) * 100
    percent > 100 ? 100 : percent
  end
  
  scope :by_user, lambda{ |uid| joins(:video).where(:videos => {:user_id => uid} ) }

end
