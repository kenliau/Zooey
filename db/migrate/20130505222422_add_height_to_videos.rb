class AddHeightToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :height, :integer
  end
end
