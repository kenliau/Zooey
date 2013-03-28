require 'spec_helper'

describe JobsController do
  before do
    $redis.flushdb
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
    end
  end

end
