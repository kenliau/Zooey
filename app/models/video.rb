class Video < ActiveRecord::Base
  belongs_to :user
  has_many :jobs
  attr_accessible :duration, :filename, :frame_distance, :gop_length, :location, :size
end
