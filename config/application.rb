require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PicSphere
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # config.before_configuration do
    #   Aws.config.update({
    #     region: 'your_aws_region', # Replace with your AWS region, e.g., 'us-east-1'
    #     credentials: Aws::Credentials.new(
    #       ENV['AWS_ACCESS_KEY_ID'],
    #       ENV['AWS_SECRET_ACCESS_KEY']
    #     ),
    #   })
    # end

    config.action_cable.mount_path = '/cable'

    
  end
end
