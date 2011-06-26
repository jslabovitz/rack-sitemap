require 'rack'
require 'nokogiri'
require 'uri'

module Rack

  class Sitemap
  
    # http://www.sitemaps.org/protocol.php
  
    def initialize(app, options={})
      @app = app
      @path = options[:path] or raise "Must specify path"
      @sitemap = options[:sitemap] or raise "Must specify sitemap"
      @base_uri = options[:base_uri] or raise "Must specify base URI"
      @base_uri = URI.parse(@base_uri) unless @base_uri.kind_of?(URI)
      @default_frequency = options[:default_frequency] || :weekly
    end
    
    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.urlset('xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9',
                   'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                   'xsi:schemaLocation' => 'http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd') do
          @sitemap.each do |resource|
            res = Hash[
              %w{path last_modified frequency}.map do |key|
                if resource.respond_to?(key)
                  value = resource.method(key).call
                elsif resource.respond_to?(:fetch)
                  value = resource[key] || resource[key.to_sym]
                else
                  raise "Can't fetch #{key.inspect} key from #{resource.inspect}"
                end
                [key.to_sym, value]
              end
            ]
            xml.url do
              xml.loc(@base_uri.merge(res[:path].to_s))
              xml.lastmod(res[:last_modified].iso8601)
              xml.changefreq((res[:frequency] || @default_frequency).to_s)
            end
          end
        end
      end
      builder.doc.to_s
    end
    
    def call(env)
      if env['PATH_INFO'] == @path
        response = Rack::Response.new
        response.header['Content-Type'] = 'text/xml'
        response.body = [to_xml]
        response.finish
      else
        @app.call(env)
      end
    end
  
  end

end