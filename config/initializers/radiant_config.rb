config_hash = Radiant::Config.to_hash
Radiant::Config["mobile.redirect?"] = true unless config_hash.has_key?("mobile.redirect?")
Radiant::Config["mobile.host"] = nil unless config_hash.has_key?("mobile.host")