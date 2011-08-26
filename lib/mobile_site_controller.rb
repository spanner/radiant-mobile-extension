module MobileSiteController
  # approach and UA strings borrowed from mobile-fu
  # http://github.com/brendanlim/mobile-fu/tree/master
  MOBILE_USER_AGENTS = 'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                       'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                       'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                       'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                       'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|' +
                       'mobile'

  def mobile?
    unless mobile_host = Radiant::Config['mobile.host'].blank?
      request.host == mobile_host
    else
      request.host =~ /^m\./
    end
  end

  def mobile_device?
    request.user_agent.to_s.downcase =~ Regexp.new(MobileSiteController::MOBILE_USER_AGENTS)
  end

  def process_page_with_mobile(page)
    page.mobile = mobile?
    process_page_without_mobile(page)
  end

  def redirect_if_mobile
    if params['url'] =~ /\?mobile/
      session[:nomobile] = false
    elsif params['url'] =~ /\?nomobile/
      session[:nomobile] = true
    end
    if Radiant::Config['mobile.redirect?'] && Radiant::Config['mobile.host'] && !session[:nomobile] && !mobile? && mobile_device?
      uri = request.path_parameters['url']
      uri = uri.join('/') if uri.respond_to? :join
      redirect_to request.protocol + Radiant::Config['mobile.host'] + uri
    end
  end

  def self.included(base)
    base.class_eval do
      before_filter :redirect_if_mobile
      alias_method_chain :process_page, :mobile
    end
  end
end