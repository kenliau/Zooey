class AddInputBitrateToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :audio_bitrate, :integer
  end
end
