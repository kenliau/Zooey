class AddDetailsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :ouptut_url, :string
    add_column :jobs, :output_size, :integer
  end
end
