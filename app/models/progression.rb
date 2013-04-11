class Progression < ActiveRecord::Base
  belongs_to :job
  attr_accessible :chunk_tcode_time, :chunker_finish_time, :chunker_start_time, :chunks, :merger_finish_time, :merger_start_time, :pull_finish_time, :pull_start_time, :tcoder_finish_time, :tcoder_start_time

  after_create :set_in_redis
  after_update :set_in_redis
  before_destroy :delete_in_redis
 
  def set_in_redis
    status = self.status_hash.to_json.to_s
    $redis.set(Progression.redis_key(self.job.id), status)
  end

  def delete_in_redis
    $redis.del(Progression.redis_key(self.job.id))
    true
  end

  def status_hash
    {
      size: self.job.video.size, 
      processed: 0
    }
  end
  
  def self.status_by_job_id(job_id)
    status = $redis.get(self.redis_key(job_id))
    unless status.nil?
      JSON.parse(status) 
    else
      progression = Progression.where(:job_id => job_id).first
      progression.status_hash unless progression.nil?
    end
  end

  def self.redis_key(job_id)
    "progression_status:#{job_id}"
  end

  scope :by_user, lambda{ |uid| joins(:job => :video ).where(:videos => {:user_id => uid}) }


end
