require 'spec_helper'

describe DocumentationsController do
  
  describe "GET show" do
    
    context 'with id of job stored' do
      it 'returns a job thats in redis' do
        $redis.sadd(555, 3)
        get :show, id: 555, format: 'json'
        response.body[:state].should == '4'
      end
    end
  end
end
