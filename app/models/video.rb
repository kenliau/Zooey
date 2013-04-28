class Video < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :user
  has_many :jobs, :dependent => :destroy
  attr_accessible :duration, :video_name, :filename, :frame_distance, :gop_length, :location, :size

  validate :valid_url?

  validates :filename,
    :presence => {
      :unless => :location?,
      message: "or an URL to a video is required"
    }

  validates :video_name,
    :presence => {
      message: "is a required field"
    }

  validates :frame_distance, :gop_length,
    :numericality => {
      :only_integer => true,
      :greater_than => 0
    }

  validates :size,
    :numericality => {
      :greater_than => 0
    }

  scope :by_user, lambda{ |uid| where(user_id: uid)}

  def valid_url?
    require "net/http"
    begin
      Rack::Utils.escape(location)
      url = URI.parse(location)
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      if res.code != "200"
        errors.add(:location, "is invalid")
      end
    rescue Exception => e
      errors.add(:location, "is invalid")
    end
  end

end
