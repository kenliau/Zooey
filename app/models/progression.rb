class Progression < ActiveRecord::Base
  belongs_to :job
  attr_accessible :chunk_tcode_time, :chunker_finish_time, :chunker_start_time, :chunks, :chunks_tcoded_so_far, :merger_finish_time, :merger_start_time, :pull_finish_time, :pull_start_time, :tcoder_finish_time, :tcoder_start_time

  after_create :store_in_redis
  after_update :set_in_redis
  before_destory :delete_in_redis
 
  def set_in_redis
    status = {size: self.job.video.size, processed: 0}
    $redis.set(self.redis_key, status)
  end

  def delete_in_redis
    $redis.del(self.redis_key)
    true
  end

  def self.status_by_job_id
    $redis.get(self.redis_key)
  end

  def self.redis_key
    "progression_status:#{job.id}"
  end
end
