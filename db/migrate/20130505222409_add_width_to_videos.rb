class AddWidthToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :width, :integer
  end
end
