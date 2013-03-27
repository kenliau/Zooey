require 'spec_helper'

describe Video do

  describe 'Validations' do

    it 'fails without a filename' do
      FactoryGirl.build(:video, filename: nil).should_not be_valid
    end

    it 'fails when frame_distance or gop_length are floats' do
      FactoryGirl.build(:video, frame_distance: 12.3).should_not be_valid
      FactoryGirl.build(:video, gop_length: 12.3).should_not be_valid
    end

    it 'fails when frame_distance, gop_length, or size are less than or equal to 0' do
      FactoryGirl.build(:video, frame_distance: 0).should_not be_valid
      FactoryGirl.build(:video, gop_length: 0).should_not be_valid
      FactoryGirl.build(:video, size: 0).should_not be_valid

      FactoryGirl.build(:video, frame_distance: -10).should_not be_valid
      FactoryGirl.build(:video, gop_length: -10).should_not be_valid
      FactoryGirl.build(:video, size: -10).should_not be_valid
    end

    it 'is valid when filename is present, frame_distance, gop_length, & size' +
       ' are numbers greater than 0, and frame_distance & gop_length are ' +
       'integers' do

      FactoryGirl.build(:video, {
        filename: 'Example',
        frame_distance: 2,
        gop_length: 3,
        size: 2.4
      }).should be_valid
    end

  end

end
