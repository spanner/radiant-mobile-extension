require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  dataset :pages
  
  before do
    @host = "m.test.host"
    @page = pages(:first)
    Radiant::Config['mobile.host'] = @host
    Radiant::Config['mobile.redirect?'] = true
  end
  
  describe "responding to a mobile-site request" do
    before do
      request.stub!(:host).and_return("m.test.host")
      controller.stub!(:find_page).and_return(@page)
    end

    it "should notice that this is a request for the mobile site" do
      controller.mobile?.should be_true
    end

    it "should set the mobile flag on a processed page to true" do
      @page.should_receive(:mobile=).with(true)
      get :show_page, :url => @page.url
    end
  end

  describe "responding to an app-site request" do
    before do
      request.stub!(:host).and_return("app.test.host")
      controller.stub!(:find_page).and_return(@page)
    end

    it "should notice that this is a request for the app site" do
      controller.app?.should be_true
    end

    it "should set both the mobile and app flags on a processed page to true" do
      @page.should_receive(:mobile=).with(true)
      @page.should_receive(:app=).with(true)
      get :show_page, :url => @page.url
    end
  end
  
  describe "responding to a standard-site request" do
    before do
      request.stub!(:host).and_return('test.host')
      controller.stub!(:find_page).and_return(@page)
    end

    it "should notice that this is not a request for the mobile site" do
      controller.mobile?.should be_false
    end

    it "should set the mobile flag on a processed page to false" do
      @page.should_receive(:mobile=).with(false)
      get :show_page, :url => @page.url
    end
    
    describe "from a mobile device" do
      before do
        controller.stub!(:mobile_device?).and_return(true)
      end
      
      it "should redirect to the mobile site" do
        get :show_page, :url => @page.url
        response.should be_redirect
        response.should redirect_to("http://#{@host}#{@page.url}")
      end
      
      describe "inisting on the standard site" do
        before do
          get :show_page, :url => "#{@page.url}?nomobile"
        end
        
        it "should not redirect to the mobile site" do
          response.should_not be_redirect
        end

        it "should set a nomobile session flag" do
          session[:nomobile].should be_true
        end
      end
      
    end
  end
end