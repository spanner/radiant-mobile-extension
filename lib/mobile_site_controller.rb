module MobileSiteController
  #
  # This extends the normal site controller in two ways: if we detect a mobile device,
  # we can redirect to the corresponding page in a mobile site, and if we are on the mobile
  # site we set a flag on the page that radius tags can use to select content.
  
  
  # approach and UA strings borrowed from mobile-fu
  # http://github.com/brendanlim/mobile-fu/tree/master
  MOBILE_USER_AGENTS = 'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                       'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                       'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                       'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                       'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|' +
                       'mobile'

  # Returns true if the requested host matches the defined mobile host
  # (or in the absence of such a definition, if the host begins m.)
  #
  def mobile?
    mobile_host = Radiant.config['mobile.host']
    unless mobile_host.blank?
      request.host == mobile_host
    else
      request.host =~ /^m\./
    end
  end

  # Returns true if the request comes from a mobile device
  # (based on the supplied user-agent string)
  #
  def mobile_device?
    request.user_agent.to_s.downcase =~ Regexp.new(MobileSiteController::MOBILE_USER_AGENTS)
  end

  # Extends the process_page method to place a 'mobile' flag in the page-rendering 
  # context to support presentation choices in radius tags.
  #
  def process_page_with_mobile(page)
    page.mobile = mobile?
    process_page_without_mobile(page)
  end

  # Issues a redirect to the mobile site if this request comes from a mobile device, and if the
  # mobile site is configured, and if the request does not have a 'nomobile' parameter.
  # If there is a 'nomobile' parameter, a session marker is placed to indicate that the browser
  # should not be redirected in future.
  #
  def redirect_if_mobile
    if params['url'] =~ /\?mobile/
      session[:nomobile] = false
    elsif params['url'] =~ /\?nomobile/
      session[:nomobile] = true
    end
    if @config['mobile.redirect?'] && @config['mobile.host'] && !session[:nomobile] && !mobile? && mobile_device?
      uri = request.path_parameters['url']
      uri = uri.join('/') if uri.respond_to? :join
      redirect_to request.protocol + @config['mobile.host'] + uri
    end
  end

  def self.included(base) #:nodoc:
    base.class_eval do
      before_filter :redirect_if_mobile
      alias_method_chain :process_page, :mobile
    end
  end

end