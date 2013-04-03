class Video < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  belongs_to :user
  has_many :jobs
  attr_accessible :duration, :video_name, :filename, :frame_distance, :gop_length, :location, :size

  validates :filename, :video_name,
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



end
