require 'spec_helper'

describe JobsController do
  include Devise::TestHelpers

  before do
    $redis.flushdb
  end

  describe 'Authentication filter' do

    context 'when user is guest' do
      it 'should redirect when trying to reach index' do
        get 'index'
        response.should be_redirect
      end

      it 'should redirect when trying to reach show' do
        get 'show', id: 1
        response.should be_redirect
      end

      it 'should redirect when trying to reach destroy' do
        delete 'destroy', id: 1
        response.should be_redirect
      end
    end

    #context 'when user is signed in and not an admin' do
    #user = FactoryGirl.create(:user, :email => 'nonadminjobs@email.com')
    #sign_in user

    #it 'should allow index to load index' do
    #get 'index'
    #response.should_not be_success
    #end
    #end

  end

  describe 'Load Job filter' do

    context 'should redirect if no job was found' do

    end
  end

  describe 'GET job_progression' do
    it 'returns 404 when no matching job' do
      get :job_progression, format: 'json', job_id: 555
      response.status.should == 404
    end

    context 'when there is a matching job' do
      before do
        @progression = FactoryGirl.create(:progression)
      end

      it 'returns a proper status' do
        get :job_progression, format: "json", job_id: @progression.job.id
        status = JSON.parse(response.body)
        status["size"].should == @progression.job.video.size
        status["processed"].should == @progression.chunks_tcoded_so_far
      end

      context 'when redis fails' do
        before do
          $redis.flushdb
        end

        it 'returns a proper status' do
          get :job_progression, format: "json", job_id: @progression.job.id
          status = JSON.parse(response.body)
          status["size"].should == @progression.job.video.size
          status["processed"].should == @progression.chunks_tcoded_so_far
        end
      end
    end
  end
end
