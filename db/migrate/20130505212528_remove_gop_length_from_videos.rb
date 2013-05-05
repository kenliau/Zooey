class RemoveGopLengthFromVideos < ActiveRecord::Migration
  def up
    remove_column :videos, :gop_length
  end

  def down
    add_column :videos, :gop_length, :integer
  end
end
