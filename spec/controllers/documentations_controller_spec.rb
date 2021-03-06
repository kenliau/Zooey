require 'spec_helper'
describe DocumentationsController do
 
  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all documentations as @documentations" do
      documentation = Documentation.create! valid_attributes
      get :index, {}, valid_session
      assigns(:documentations).should eq([documentation])
    end
  end

  describe "GET show" do
    it "assigns the requested documentation as @documentation" do
      documentation = Documentation.create! valid_attributes
      get :show, {:id => documentation.to_param}, valid_session
      assigns(:documentation).should eq(documentation)
    end
  end

  describe "GET new" do
    it "assigns a new documentation as @documentation" do
      get :new, {}, valid_session
      assigns(:documentation).should be_a_new(Documentation)
    end
  end

  describe "GET edit" do
    it "assigns the requested documentation as @documentation" do
      documentation = Documentation.create! valid_attributes
      get :edit, {:id => documentation.to_param}, valid_session
      assigns(:documentation).should eq(documentation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Documentation" do
        expect {
          post :create, {:documentation => valid_attributes}, valid_session
        }.to change(Documentation, :count).by(1)
      end

      it "assigns a newly created documentation as @documentation" do
        post :create, {:documentation => valid_attributes}, valid_session
        assigns(:documentation).should be_a(Documentation)
        assigns(:documentation).should be_persisted
      end

      it "redirects to the created documentation" do
        post :create, {:documentation => valid_attributes}, valid_session
        response.should redirect_to(Documentation.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved documentation as @documentation" do
        # Trigger the behavior that occurs when invalid params are submitted
        Documentation.any_instance.stub(:save).and_return(false)
        post :create, {:documentation => {}}, valid_session
        assigns(:documentation).should be_a_new(Documentation)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Documentation.any_instance.stub(:save).and_return(false)
        post :create, {:documentation => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested documentation" do
        documentation = Documentation.create! valid_attributes
        # Assuming there are no other documentations in the database, this
        # specifies that the Documentation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Documentation.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => documentation.to_param, :documentation => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested documentation as @documentation" do
        documentation = Documentation.create! valid_attributes
        put :update, {:id => documentation.to_param, :documentation => valid_attributes}, valid_session
        assigns(:documentation).should eq(documentation)
      end

      it "redirects to the documentation" do
        documentation = Documentation.create! valid_attributes
        put :update, {:id => documentation.to_param, :documentation => valid_attributes}, valid_session
        response.should redirect_to(documentation)
      end
    end

    describe "with invalid params" do
      it "assigns the documentation as @documentation" do
        documentation = Documentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Documentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => documentation.to_param, :documentation => {}}, valid_session
        assigns(:documentation).should eq(documentation)
      end

      it "re-renders the 'edit' template" do
        documentation = Documentation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Documentation.any_instance.stub(:save).and_return(false)
        put :update, {:id => documentation.to_param, :documentation => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested documentation" do
      documentation = Documentation.create! valid_attributes
      expect {
        delete :destroy, {:id => documentation.to_param}, valid_session
      }.to change(Documentation, :count).by(-1)
    end

    it "redirects to the documentations list" do
      documentation = Documentation.create! valid_attributes
      delete :destroy, {:id => documentation.to_param}, valid_session
      response.should redirect_to(documentations_url)
    end
  end

end
