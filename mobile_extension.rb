# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class MobileExtension < Radiant::Extension
  version "1.0"
  description "Defines a mobile site context and corresponding if_mobile radius tags"
  url "http://github.com/spanner/radiant-mobile-extension"
  
  def activate
    Page.send :include, MobilePage
    SiteController.send :include, MobileSiteController
    
    admin.configuration.show.add :config, "mobile", :after => "defaults"
    admin.configuration.edit.add :form, "edit_mobile", :after => "edit_defaults"
  end
end
