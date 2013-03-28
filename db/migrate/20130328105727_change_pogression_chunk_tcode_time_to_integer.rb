class ChangePogressionChunkTcodeTimeToInteger < ActiveRecord::Migration
  def up
    change_table :progressions do |t|
      t.remove :chunk_tcode_time
      t.column :chunk_tcode_time, :integer, default: 0
    end
  end

  def down
    change_table :videos do |t|
      t.remove :chunk_tcode_time
      t.column :chunk_tcode_time, :time
    end
  end
end
