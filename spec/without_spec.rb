require File.join(File.dirname(__FILE__), *%w[abstract_spec])

describe "without scope" do

  before do
    uses_fixture(:article)
    # Stub these so it doesn't try to hit the (non-existant) database
    Article.stub!(:quoted_table_name).and_return("'articles'")
    Article.stub!(:primary_key).and_return('id')
  end

  it "should not change the scope with nil" do
    Article.without(nil).proxy_options.should == {}
  end

  it "should return all items without the one specified" do
    item = 123
    Article.without(item).proxy_options.should == {:conditions => ["'articles'.id NOT IN (?)", item]}
  end

  it "should return all items without ones in the list specified" do
    list = [123, 456, 7]
    Article.without(list).proxy_options.should == {:conditions => ["'articles'.id NOT IN (?)", list]}
  end
end
