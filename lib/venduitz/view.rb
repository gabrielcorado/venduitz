#
module Venduitz
  #
  class View
    # Static methods
    class << self
      # Properties
      attr_reader :props, :collects

      # Define a property for the view
      # @param {Symbol/String} name Name used as the JSON field
      # @param {Proc} prc If its necessary pass a Proc to generate
      #                   the value used  by the generator
      def prop(name, prc = nil)
        # Initialize it if its necessary
        @props = {} if @props.nil?

        # Define!
        @props[name] = prc.nil? ? name : prc
      end

      # Define a collection for it
      def collection(name, view, prc = nil)
        # Initialize it if its necessary
        @collects = {} if @collects.nil?

        # Define the collection
        @collects[name] = {
          view: view,
          value: (prc.nil? ? name : prc)
        }
      end

      # This method will generate the hash object
      # based on the properties and the colletions
      # for the specific argument
      # @param {Object} obj This must contain the declared properies and collections
      # @return {Hash} JSON ready hash containing the specified view fields
      def generate(obj)
        # Reset the values to prevent errors
        @props = {} if @props.nil?
        @collects = {} if @collects.nil?

        # Return the properties
        res = @props.map do |prop, value|
          next [prop, obj.send(value)] if value.is_a?(Symbol)
          [prop, value.call(obj)]
        end

        # Return the collections
        coll = @collects.map do |collect, info|
          values = info[:value].is_a?(Symbol) ? obj.send(info[:value]) : info[:value].call(obj)
          next [collect, []] if values.nil? || values.empty?
          [collect, values.map {|val| info[:view].to_json(val) }]
        end

        # Return the full hash
        Hash[res].merge(Hash[coll])
      end

      # Parse it
      # @param {Object} obj This must contain the declared properies and collections
      # @return {Hash} The JSON string itself
      def to_json(obj)
        # Transform the result into json
        MultiJson.dump generate(obj)
      end
    end
  end
end
