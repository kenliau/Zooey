require 'spec_helper'

describe "documentations/show" do
  before(:each) do
    @documentation = assign(:documentation, stub_model(Documentation,
      :title => "Title",
      :content => "Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Content/)
  end
end
