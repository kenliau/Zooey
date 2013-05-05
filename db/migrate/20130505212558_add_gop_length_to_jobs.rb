class AddGopLengthToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :gop_length, :integer
  end
end
