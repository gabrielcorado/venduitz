#
module Venduitz
  #
  module Grape
    # Call method
    def self.call(object, env)
      # Define the Venduitz representer
      representer = env['api.endpoint'].options.fetch(:route_options, {})[:venduitz]

      # Must define the Representer in the endpoint
      raise 'Must define the Venduitz in the endpoind' if representer.nil?

      # Render it!
      representer.to_json object
    end
  end
end
