class RenameColumnName < ActiveRecord::Migration
  def up
    rename_column :jobs, :ouptut_url, :output_url
  end

  def down
  end
end
