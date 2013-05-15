class AddFinalSpeedToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :final_pull_speed, :int
    add_column :jobs, :final_transcode_speed, :int
  end
end
