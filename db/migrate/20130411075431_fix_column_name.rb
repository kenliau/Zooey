class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :progressions, :errors, :progress_errors
  end
end
