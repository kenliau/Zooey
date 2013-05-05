class AddInputCodecToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :audio_codec, :string
  end
end
