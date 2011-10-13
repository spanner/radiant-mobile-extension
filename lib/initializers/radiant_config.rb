Radiant.config do |config|
  config.namespace('mobile') do |mob|
    mob.define 'host', :allow_blank => true
    mob.define 'redirect?', :default => true
  end
end 
