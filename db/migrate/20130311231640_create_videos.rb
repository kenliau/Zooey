class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :user
      t.string :filename
      t.string :location
      t.float :size
      t.time :duration
      t.integer :frame_distance
      t.integer :gop_length

      t.timestamps
    end
    add_index :videos, :user_id
  end
end
