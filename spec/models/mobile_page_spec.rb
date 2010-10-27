require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  let(:page){ 
    Page.new(:title => "Page", :slug => "page", :breadcrumb => "page", :status_id => '1')
  }

  it "should get and set a mobile? attribute" do
    page.mobile?.should be_false
    lambda{ page.mobile = true }.should_not raise_error
    page.mobile.should be_true
    page.mobile?.should be_true
  end
end
