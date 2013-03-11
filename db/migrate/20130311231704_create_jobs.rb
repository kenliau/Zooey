class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :video
      t.integer :width
      t.integer :height
      t.string :h264_profile
      t.string :h264_quality
      t.string :audio_codec
      t.integer :audio_bitrate
      t.integer :audio_volume
      t.integer :mux_rate
      t.datetime :finished_at

      t.timestamps
    end
    add_index :jobs, :video_id
  end
end
