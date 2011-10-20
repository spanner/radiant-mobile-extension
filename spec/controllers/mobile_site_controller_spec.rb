require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do
  dataset :pages
  
  before do
    @host = "m.test.host"
    @page = pages(:first)
    Radiant.config['mobile.host'] = @host
    Radiant.config['mobile.redirect?'] = true
    Radiant.config['mobile.ua.positive'] = "palm,blackberry,nokia,phone,midp,mobi,symbian,chtml,ericsson,minimo,audiovox,motorola,samsung,telit,upg1,windows,ce,ucweb,astel,plucker,x320,x240,j2me,sgh,portable,sprint,docomo,kddi,softbank,android,mmp,pdxgw,netfront,xiino,vodafone,portalmmm,sagem,mot-,sie-,ipod,webos,amoi,novarra,cdm,alcatel,pocket,iphone,mobileexplorer,mobile"
    Radiant.config['mobile.ua.negative'] = "ipad"
    Radiant.config['mobile.ua.required'] = "mobile"
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
    
    describe "detecting devices:" do
      describe "android phone" do
        before do
          request.stub!(:user_agent).and_return("Mozilla/5.0 (Linux; U; Android 2.2.1; en-us; Nexus One Build/FRG83) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1")
        end
        it "should be mobile" do
          controller.mobile_device?.should be_true
        end
      end
      describe "iphone" do
        before do
          request.stub!(:user_agent).and_return("Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C25 Safari/419.3")
        end
        it "should be mobile" do
          controller.mobile_device?.should be_true
        end
      end
      describe "android tablet" do
        before do
          request.stub!(:user_agent).and_return("Mozilla/5.0 (Linux; U; Android 2.2.1; en-us; device Build/FRG83) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Safari/533.1")
        end
        it "should not be mobile" do
          controller.mobile_device?.should be_false
        end
      end
      describe "ipad" do
        before do
          request.stub!(:user_agent).and_return("Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10")
        end
        it "should not be mobile" do
          controller.mobile_device?.should be_false
        end
      end
      describe "with configured ua fragments" do
        before do
          Radiant.config['mobile.ua.positive'] = 'foo,bar,baz'
          request.stub!(:user_agent).and_return("Mozilla/5.0 (Foo) Mobile")
        end
        it "should be mobile" do
          controller.mobile_device?.should be_true
        end
      end
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