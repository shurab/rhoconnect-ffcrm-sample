require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "Lead" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Lead,'testuser'
    end

    it "should process Lead query" do
      pending
    end

    it "should process Lead create" do
      pending
    end

    it "should process Lead update" do
      pending
    end

    it "should process Lead delete" do
      pending
    end
  end  
end