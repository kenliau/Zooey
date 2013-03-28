FactoryGirl.define do
  factory :progression do
    chunks 5
    chunks_tcoded_so_far 5
    pull_start_time Time.now - 6.minutes
    chunker_start_time Time.now - 5.minutes
    chunker_finish_time Time.now - 4.minutes
    tcoder_start_time Time.now - 3.minutes
    tcoder_finish_time Time.now - 2.minutes
    merger_start_time Time.now - 1.minute
    merger_finish_time Time.now
    chunk_tcode_time 7.minutes
    job
  end
end
