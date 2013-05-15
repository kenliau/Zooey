class RenameColumnsNames < ActiveRecord::Migration
  def up
    rename_column :videos, :audio_codec, :video_codec
    rename_column :videos, :audio_bitrate, :video_bitrate
    rename_column :jobs, :mux_rate, :video_mux_rate
  end

  def down
  end
end
