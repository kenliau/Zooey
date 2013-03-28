FactoryGirl.define do
  factory :job do
    width 640
    height 480
    h264_profile "baseline"
    h264_quality "17"
    audio_codec "passthrough"
    audio_bitrate 24
    audio_volume 100
    mux_rate 500
    finished_at Time.now
    video
  end
end
