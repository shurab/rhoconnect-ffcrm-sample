require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "Profile" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Profile,'testuser'
    end

    it "should process Profile query" do
      pending
    end

    it "should process Profile create" do
      pending
    end

    it "should process Profile update" do
      pending
    end

    it "should process Profile delete" do
      pending
    end
  end  
end