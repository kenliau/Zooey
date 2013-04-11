class AddVideoNameToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :video_name, :string
  end
end
