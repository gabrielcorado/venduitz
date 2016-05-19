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
      def collection(name, view, opts = {})
        # Initialize it if its necessary
        @collects = {} if @collects.nil?

        # Define the collection
        @collects[name] = {
          view: view,
          value: (opts.key?(:value) ? opts[:value] : name),
          excluded: (opts.key?(:exclude) ? opts[:exclude] : [])
        }
      end

      # This method will generate the hash object
      # based on the properties and the colletions
      # for the specific argument
      # @param {Object} obj This must contain the declared properies and collections
      # @param {Array} excluded This array contain the keys that will not be added to the result
      # @param {Boolean} cache This flag indicates if cache will be performed
      # @param {Hash} cache_options Cache options
      # @return {Hash} JSON ready hash containing the specified view fields
      def generate(obj, excluded = [], cache = Cache.enabled, cache_options = Cache.config)
        # Generate the cache key if cache is enabled
        key = cache_key(obj, excluded, :generate) if cache

        # Cache?
        return Cache.get(key) if cache && Cache.exist?(key)

        # Reset the values to prevent errors
        @props = {} if @props.nil?
        @collects = {} if @collects.nil?

        # Map both props and collects
        props = @props.select { |prop, value| !excluded.include?(prop) }
        coll = @collects.select { |prop, value| !excluded.include?(prop) }

        # Return the properties
        props = props.map do |prop, value|
          next [prop, obj.send(value)] if value.is_a?(Symbol)
          [prop, value.call(obj)]
        end

        # Return the collections
        coll = coll.map do |collect, info|
          values = info[:value].is_a?(Symbol) ? obj.send(info[:value]) : info[:value].call(obj)
          next [collect, []] if values.nil? || values.empty?
          [collect, values.map {|val| info[:view].generate(val, info[:excluded]) }]
        end

        # Full hash
        result = Hash[props].merge(Hash[coll])

        # Check if cache has to be created
        Cache.set(key, result, cache_options) if cache

        # Return the result
        result
      end

      # Parse it
      # @param {Object} obj This must contain the declared properies and collections
      # @param {Array} excluded This array contain the keys that will not be added to the result
      # @param {Boolean} cache This flag indicates if cache will be performed
      # @param {Hash} cache_options Cache options
      # @return {Hash} The JSON string itself
      def to_json(obj, excluded = [], cache = Cache.enabled, cache_options = Cache.config)
        # Generate the cache key if cache is enabled
        key = cache_key(obj, excluded, :json) if cache

        # Cache?
        return Cache.get(key) if cache && Cache.exist?(key)

        # Transform the result into json
        result = MultiJson.dump generate(obj, excluded)

        # Cache must be performed?
        Cache.set(key, result, cache_options) if cache

        # Return the result
        result
      end

      #
      private

      # Generate the cache key
      # CACHE
      #   Key: "{object}/{excluded}/{type}"
      def cache_key(obj, excluded, type)
        "#{Cache.digest(obj)}/#{Cache.digest(excluded)}/#{type.to_s}"
      end
    end
  end
end
