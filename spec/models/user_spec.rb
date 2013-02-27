require 'spec_helper'

describe User do
  
  describe 'factory' do
    it 'has a valid factory' do
      FactoryGirl.build(:user).should be_valid
    end
  end

  describe 'validations' do
    it 'fails w/out first_name' do
      FactoryGirl.build(:user, first_name: nil).should_not be_valid
    end
    
    it 'fails w/out last_name' do
      FactoryGirl.build(:user, last_name: nil).should_not be_valid
    end
    
    it 'fails w/out email' do
      FactoryGirl.build(:user, email: nil).should_not be_valid
    end
    
    it 'fails w/out membership' do
      FactoryGirl.build(:user, membership: nil).should_not be_valid
    end

    it 'fails w/out membership' do
      FactoryGirl.build(:user, membership: nil).should_not be_valid
    end

    it 'fails on invalid email' do
      FactoryGirl.build(:user, email: 'notValidEmail').should_not be_valid
    end

    it 'fails with a password less than six characters' do
      FactoryGirl.build(:user, password: '12345').should_not be_valid
    end
    
    it 'fails with a membership greater than 2' do
      FactoryGirl.build(:user, membership: 3).should_not be_valid
    end
  
    it 'fails with a membership less than 0' do
      FactoryGirl.build(:user, membership: -1).should_not be_valid
    end
    
    it 'fails with a membership non-integer' do
      FactoryGirl.build(:user, membership: 1.5).should_not be_valid
    end
  end
  
  describe 'before created' do
    it 'capitalizes names' do
      lower_case_user = FactoryGirl.create :user, 
        first_name: 'devon', last_name: 'peticolas'
      lower_case_user.first_name.should == 'Devon'
      lower_case_user.last_name.should == 'Peticolas'
    end
    
    context 'is_admin not initialized' do
      it 'sets is_admin to false' do
        unset_user = FactoryGirl.create :user, is_admin: nil
        unset_user.is_admin.should == false
      end
    end

    context 'is_admin initalized' do
      it 'leaves is_admin' do
        unset_user = FactoryGirl.create :user, is_admin: true
        unset_user.is_admin.should == true
      end
    end
  end

end
