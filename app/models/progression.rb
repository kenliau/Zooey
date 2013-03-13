class Progression < ActiveRecord::Base
  belongs_to :job
  attr_accessible :chunk_tcode_time, :chunker_finish_time, :chunker_start_time, :chunks, :chunks_tcoded_so_far, :merger_finish_time, :merger_start_time, :pull_finish_time, :pull_start_time, :tcoder_finish_time, :tcoder_start_time
end
