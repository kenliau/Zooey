class Progression < ActiveRecord::Base
  belongs_to :job
  attr_accessible :chunk_tcode_time, :chunker_finish_time, :chunker_start_time, :chunks, :chunks_tcoded_so_far, :merger_finish_time, :merger_start_time, :pull_finish_time, :pull_start_time, :tcoder_finish_time, :tcoder_start_time

  after_create :set_in_redis
  after_update :set_in_redis
  before_destroy :delete_in_redis
 
  def set_in_redis
    status = {
      size: self.job.video.size, 
      processed: self.chunks_tcoded_so_far || 0
    }.to_json.to_s
    $redis.set(Progression.redis_key(self.job.id), status)
  end

  def delete_in_redis
    $redis.del(Progression.redis_key(self.job.id))
    true
  end

  
  def self.status_by_job_id(job_id)
    status = $redis.get(self.redis_key(job_id))
    JSON.parse(status) unless status.nil?
  end

  def self.redis_key(job_id)
    "progression_status:#{job_id}"
  end
end
