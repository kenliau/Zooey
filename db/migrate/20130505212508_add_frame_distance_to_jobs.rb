class AddFrameDistanceToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :frame_distance, :integer
  end
end
