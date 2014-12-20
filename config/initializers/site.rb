# checking if site.yml is here
raise "It seems that there is no site.yml config. I need it! Desired location: #{Rails.root.join('config', 'site.yml')}" unless File.exists?(Rails.root.join('config', 'site.yml'))

# Load site yaml file
site_config = File.read Rails.root.join('config', 'site.yml')


# Select environment
site_config = ActiveSupport::HashWithIndifferentAccess.new(YAML.load(site_config)[Rails.env])
 
# Setup Site object
Site = OpenStruct.new(site_config)
 
# Set ENV['DOMAIN'] to temporarily change development domain
Site.domain = (ENV['DOMAIN'] || Site.domain) if Rails.env.development?
 
# Split domain
Site.host, Site.port = Site.domain.split(':')

# Some config
ActionMailer::Base.default_url_options[:host] = Site.domain.to_s
