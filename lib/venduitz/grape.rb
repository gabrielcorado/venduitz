#
module Venduitz
  #
  module Grape
    # Call method
    def self.call(object, env)
      # Route Options
      options = env['api.endpoint'].options.fetch :route_options, {}

      # Must define the Representer in the endpoint
      raise 'Must define the Venduitz in the endpoind' if options[:venduitz].nil?

      # Representer options
      options[:exclude] ||= []

      # Define the Cache options
      options[:cache] ||= Venduitz::Cache.enabled
      options[:cache_options] ||= Venduitz::Cache.config

      # Render it!
      options[:venduitz].to_json object, options[:exclude], options[:cache], options[:cache_options]
    end
  end
end
