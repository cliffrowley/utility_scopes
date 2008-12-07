require File.join(File.dirname(__FILE__), *%w[abstract_spec])

describe "Date scope" do
  before do
    uses_fixture(:article)
  end

  describe "'after' named_scope" do
    it "should have right proxy options" do
      Article.after(:created_at, Date.parse("2008-10-10")).proxy_options.should == {:conditions=>["created_at > ?", Date.parse("2008-10-10")]}
    end
  end

  describe "'before' named_scope" do
    it "should have right proxy options" do
      Article.before(:created_at, Date.parse("2008-10-10")).proxy_options.should == {:conditions=>["created_at < ?", Date.parse("2008-10-10")]}
    end
  end
  
  describe "'on' named_scope" do
    it "should have right proxy options" do
      Article.on(:created_at, Date.parse("2008-10-10")).proxy_options.should == {:conditions=> {:created_at => Date.parse("2008-10-10")}}
    end
  end
  
  describe "method_missing" do
    it "should call 'after' named_scope and return the right proxy options" do
      require 'ostruct'
      el = OpenStruct.new({:name => 'created_at'})
      el.stub!(:type).and_return(:datetime)
      columns = [el]
      Article.stub!(:columns).and_return(columns)
      Article.created_after(Date.parse("2008-10-10")).proxy_options.should == {:conditions=>["created_at > ?", Date.parse("2008-10-10")]}
    end
    
    it "should call 'before' named_scope and return the right proxy options" do
      require 'ostruct'
      el = OpenStruct.new({:name => 'created_at'})
      el.stub!(:type).and_return(:datetime)
      columns = [el]
      Article.stub!(:columns).and_return(columns)
      Article.created_before(Date.parse("2008-10-10")).proxy_options.should == {:conditions=>["created_at < ?", Date.parse("2008-10-10")]}
    end
    
    it "should call 'on' named_scope and return the right proxy options" do
      require 'ostruct'
      el = OpenStruct.new({:name => 'created_at'})
      el.stub!(:type).and_return(:datetime)
      columns = [el]
      Article.stub!(:columns).and_return(columns)
      Article.created_at(Date.parse("2008-10-10")).proxy_options.should == {:conditions=> {"created_at" => Date.parse("2008-10-10")}}
    end
  end
end