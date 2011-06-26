# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name          = 'rack-sitemap'
  s.version       = '0.0.1'
  s.summary       = 'Generate & serve a sitemap a file.'

  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.description   = %q{
    Rack application to serve a sitemap dynamically.
  }
  s.homepage      = 'http://github.com/jslabovitz/rack-sitemap'

  s.add_dependency  'rack'
  s.add_dependency  'nokogiri'

  s.files        = Dir.glob('{bin,lib,test}/**/*') + %w(README.textile)
  s.require_path = 'lib'
end