Radiant.config do |config|
  config.define 'app.host', :allow_blank => true
  config.define 'mobile.host', :allow_blank => true
  config.define 'mobile.redirect?', :default => true
end 
