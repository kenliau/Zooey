class RemoveFrameDistanceFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :frame_distance
  end

  def down
    add_column :videos, :frame_distance, :integer
  end
end
