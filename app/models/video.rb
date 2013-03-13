class Video < ActiveRecord::Base
  belongs_to :user
  has_many :jobs
  attr_accessible :duration, :filename, :frame_distance, :gop_length, :location, :size


  validates :filename,
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

end
