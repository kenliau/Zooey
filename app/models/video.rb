class Video < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  default_scope order('created_at DESC')
  belongs_to :user
  has_many :jobs, :dependent => :destroy
  attr_accessible :duration, :video_name, :filename, :location, :size, :video_codec, :width, :height, :video_bitrate, :frames_per_sec


  validates :location,
    :presence => {
      message: "or a video file is invalid"
    }

  validates :video_name,
    :presence => {
      message: "is a required field"
    }

  validates :size,
    :numericality => {
      :greater_than => 0
    }

  scope :by_user, lambda{ |uid| where(user_id: uid)}

end
