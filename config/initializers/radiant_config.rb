Radiant.config do |config|
  config.define 'app.host', :allow_blank => true
  config.define 'mobile.host', :allow_blank => true
  config.define 'mobile.redirect?', :default => true
  config.define 'mobile.ua.positive', :allow_blank => true, :default => "palm,blackberry,nokia,phone,midp,mobi,symbian,chtml,ericsson,minimo,audiovox,motorola,samsung,telit,upg1,windows,ce,ucweb,astel,plucker,x320,x240,j2me,sgh,portable,sprint,docomo,kddi,softbank,android,mmp,pdxgw,netfront,xiino,vodafone,portalmmm,sagem,mot-,sie-,ipod,webos,amoi,novarra,cdm,alcatel,pocket,iphone,mobileexplorer,mobile"
  config.define 'mobile.ua.negative', :allow_blank => true, :default => "ipad"
  config.define 'mobile.ua.required', :allow_blank => true, :default => "mobile"
end 
