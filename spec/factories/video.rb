FactoryGirl.define do
  factory :video do
    duration 2.hours
    sequence('filename') { |n| "ExampleFile#{n}" }
    frame_distance 24
    gop_length 12
    location 'http://example.com/video'
    size 123.4
    user
  end
end
