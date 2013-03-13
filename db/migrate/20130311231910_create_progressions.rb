class CreateProgressions < ActiveRecord::Migration
  def change
    create_table :progressions do |t|
      t.references :job
      t.integer :chunks
      t.datetime :pull_start_time
      t.datetime :pull_finish_time
      t.datetime :chunker_start_time
      t.datetime :chunker_finish_time
      t.datetime :tcoder_start_time
      t.datetime :tcoder_finish_time
      t.datetime :merger_start_time
      t.datetime :merger_finish_time
      t.time :chunk_tcode_time
      t.integer :chunks_tcoded_so_far

      t.timestamps
    end
    add_index :progressions, :job_id
  end
end
