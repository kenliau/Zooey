require "spec_helper"

describe DocumentationsController do
  describe "routing" do

    it "routes to #index" do
      get("/documentations").should route_to("documentations#index")
    end

    it "routes to #new" do
      get("/documentations/new").should route_to("documentations#new")
    end

    it "routes to #show" do
      get("/documentations/1").should route_to("documentations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/documentations/1/edit").should route_to("documentations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/documentations").should route_to("documentations#create")
    end

    it "routes to #update" do
      put("/documentations/1").should route_to("documentations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/documentations/1").should route_to("documentations#destroy", :id => "1")
    end

  end
end
