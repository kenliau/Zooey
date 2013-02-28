require 'spec_helper'

describe AdminController do

  describe 'Admin only filter' do

    it 'should redirect guests to home' do
      get 'index'
      response.should be_redirect
    end

    it 'should redirect non-admins to home' do
      @user = Factory.build(:user)
      sign_in @user
      get 'index'
      response.should be_redirect
    end

    it 'should allow admins to access actions in AdminController' do
      @user = Factory.build(:user)
      @user.is_admin = true
      sign_in @user
      get 'index'
      response.should be_success
    end

  end

end
