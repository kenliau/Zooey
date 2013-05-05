class AddInputFramesPerSecToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :frames_per_sec, :float
  end
end
