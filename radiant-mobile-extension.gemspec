# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-mobile-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-mobile-extension"
  s.version     = RadiantMobileExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantMobileExtension::AUTHORS
  s.email       = RadiantMobileExtension::EMAIL
  s.homepage    = RadiantMobileExtension::URL
  s.summary     = RadiantMobileExtension::SUMMARY
  s.description = RadiantMobileExtension::DESCRIPTION

  s.add_dependency "paperclip", "~> 2.3.16"

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]

  s.post_install_message = %{
  Add this to your radiant project with a line in your Gemfile:

    gem 'radiant-mobile-extension', '~> #{RadiantMobileExtension::VERSION}'

  }

end