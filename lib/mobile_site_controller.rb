module MobileSiteController
  #
  # This extends the normal site controller in two ways: if we detect a mobile device,
  # we can redirect to the corresponding page in a mobile site, and if we are on the mobile
  # site we set a flag on the page that radius tags can use to select content.
  
  # Returns true if the requested host matches the defined mobile host
  # (or in the absence of such a definition, if the host begins m.)
  #
  def mobile?
    mobile_host = Radiant.config['mobile.host']
    match = unless mobile_host.blank?
      request.host == mobile_host
    else
      request.host =~ /^m\./
    end
    !!match
  end

  # Returns true if the requested host matches the defined app host
  # (or in the absence of such a definition, if the host begins app.)
  #
  def app?
    app_host = Radiant.config['app.host']
    match = unless app_host.blank?
      request.host == app_host
    else
      request.host =~ /^app\./
    end
    !!match
  end

  # Returns true if the request comes from a mobile device (based on the supplied user-agent string)
  #
  def mobile_device?
    ua = request.user_agent.to_s.downcase
    ua =~ Regexp.new(positive_markers.join('|')) && ua =~ Regexp.new(required_markers.join('|')) && ua !~ Regexp.new(negative_markers.join('|'))
  end
  
  # Returns the list of string fragments whose presence indicates that this is a mobile device.
  # The default list (and the approach) is borrowed from mobile-fu: https://github.com/brendanlim/mobile-fu/blob/master/lib/mobile_fu.rb
  #
  def positive_markers
    @positive_ua_markers ||= Radiant.config['mobile.ua.positive'].split(/,\s*/)
  end
  
  # Returns the list of string fragments whose presence indicates that this is a tablet and should not be treated as a mobile device.
  # eg. Ipad UA includes 'mobile' (which in this context is a false positive) and also 'ipad' (which allows us to eliminate it).
  #
  def negative_markers
    @negative_ua_markers ||= Radiant.config['mobile.ua.negative'].split(/,\s*/)
  end
  
  # Returns the list of string fragments that must be present or this is not a mobile device.
  # eg. android tablet UA includes 'android' but not 'mobile', so we require the mobile flag.
  #
  def required_markers
    @required_ua_markers ||= Radiant.config['mobile.ua.required'].split(/,\s*/)
  end

  # Extends the process_page method to place a 'mobile' and 'app' flags in the page-rendering 
  # context to support presentation choices in radius tags.
  #
  def process_page_with_mobile(page)
    page.app = app?
    page.mobile = app? || mobile?
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