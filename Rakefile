task :test do
  #FIXME
end
 
task :build => :test do
  system 'gem build rack-sitemap.gemspec'
end

task :release => :build do
  system "gem push rack-sitemap-#{Rack::Robots::VERSION}"
end