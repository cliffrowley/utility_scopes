require File.join(File.dirname(__FILE__), *%w[abstract_spec])

describe "Date scope" do
  before do
    uses_fixture(:article)
    Article.stub!(:quoted_table_name).and_return("'articles'")
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
  
  describe "'between' named_scope" do
    it "should have right proxy options" do
      Article.between(:created_at, Date.parse("2008-10-10"), Date.parse("2009-10-10")).proxy_options.should == {:conditions=> ["created_at BETWEEN ? AND ?", Date.parse("2008-10-10"), Date.parse("2009-10-10")] }
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
    
    it "should call 'between' named_scope and return the right proxy options" do
      require 'ostruct'
      el = OpenStruct.new({:name => 'created_at'})
      el.stub!(:type).and_return(:datetime)
      columns = [el]
      Article.stub!(:columns).and_return(columns)
      Article.created_between(Date.parse("2008-10-10"), Date.parse("2009-10-10")).proxy_options.should == {:conditions=> ["created_at BETWEEN ? AND ?", Date.parse("2008-10-10"), Date.parse("2009-10-10")] }
    end
  end
end