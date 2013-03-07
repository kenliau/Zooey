require 'spec_helper'

describe AdminController do
  include Devise::TestHelpers

  describe 'Admin only filter' do

    it 'should redirect guests to home' do
      get 'index'
      response.should be_redirect
    end

    it 'should redirect non-admins to home' do
      user = FactoryGirl.create(:user)
      sign_in user
      get 'index'
      response.should be_redirect
    end

    it 'should allow admins to access actions in AdminController' do
      admin_user = FactoryGirl.create(:user, is_admin: true)
      sign_in admin_user
      get 'index'
      response.should be_success
    end

  end
end
