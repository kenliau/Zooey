class RemoveDetailsFromProgressions < ActiveRecord::Migration
  def up
    remove_column :progressions, :chunks
    remove_column :progressions, :chunks_tcoded_so_far
  end

  def down
    add_column :progressions, :chunks_tcoded_so_far, :integer
    add_column :progressions, :chunks, :integer
  end
end
