require 'spec_helper'

describe VideosController do

  # This should return the minimal set of attributes required to create a valid
  # Video. As you add validations to Video, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VideosController. Be sure to keep this updated too.
  def valid_session
    {}
  end
'''
  describe "GET videos index" do
    it "assigns all videos as @videos" do
      video = Video.create! valid_attributes
      get :index, {}, valid_session
      assigns(:videos).should eq([video])
    end
  end
'''


end
