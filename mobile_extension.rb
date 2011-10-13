# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class MobileExtension < Radiant::Extension
  version RadiantMobileExtension::VERSION
  description RadiantMobileExtension::DESCRIPTION
  url RadiantMobileExtension::URL
  
  def activate
    Page.send :include, MobilePage
    SiteController.send :include, MobileSiteController
    
    admin.configuration.show.add :config, "mobile", :after => "defaults"
    admin.configuration.edit.add :form, "edit_mobile", :after => "edit_defaults"
  end
end
