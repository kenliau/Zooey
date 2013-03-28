require 'spec_helper'

describe TrackerController do
  
  describe "GET show" do
    context 'with id of job stored' do
      it 'returns a job thats in redis' do
        pending 'Wizard'
        $redis.set(555, 3)
        get :show, id: 555, format: 'json'
        body = JSON.parse(response.body)
        body["state"].should == '3'
      end
    end
  end

#  describe "POST create" do
#    context 'stores a job with the id' do
#      it 'returns a job thats in redis' do
#        get :show, id: 555, format: 'json'
#        $redis.get('job:555').should == 
#        body = JSON.parse(response.body)
#        body["state"].should == '3'
#      end
#    end
#  end
end
