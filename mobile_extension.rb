# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class MobileExtension < Radiant::Extension
  version "0.1.4"
  description "An easy, cache-friendly mobile version of your site"
  url "http://github.com/spanner/radiant-mobile-extension"

  def activate
    require 'config/initializers/radiant_config'

    Page.send :include, MobilePage
    SiteController.send :include, MobileSiteController
  end
end
