require File.join(File.dirname(__FILE__),'..','..','spec_helper')

describe "Contact" do
  it_should_behave_like "SpecHelper" do
    before(:each) do
      setup_test_for Contact,'testuser'
    end

    it "should process Contact query" do
      pending
    end

    it "should process Contact create" do
      pending
    end

    it "should process Contact update" do
      pending
    end

    it "should process Contact delete" do
      pending
    end
  end  
end