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

      # Vendtuiz options
      view_options = options[:venduitz_options] or {}

      # Representer options
      view_options[:exclude] ||= []

      # Define the Cache options
      view_options[:cache] ||= Venduitz::Cache.enabled
      view_options[:cache_options] ||= Venduitz::Cache.config

      # Render it!
      options[:venduitz].to_json object, view_options[:exclude], view_options[:cache], view_options[:cache_options]
    end
  end
end
