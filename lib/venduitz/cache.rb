#
module Venduitz
  # Module responsible for creating an interface
  # for the different cache storages
  module Cache
    # Static methods
    class << self
      #
      attr_accessor :digestor, :driver, :namespace

      # Before use it you have to specify the driver used by
      # this module. The driver must define the following
      # methods:
      #   - exist?(key)
      #   - get(key)
      #   - set(key, value, options)
      #   - clear(options)

      # Digest
      def digest(object)
        # The dumped data
        dump = Marshal::dump(object)

        # Check if the digestor is empty
        digestor = Digest::MD5 if digestor.nil?

        # Digest it
        digestor.hexdigest dump
      end

      # Check if the key exists
      def exist?(key)
        _driver.exist?(key)
      end

      # Get the key
      def get(key)
        # Using the driver itself
        _driver.get(key)
      end

      # Set the cache
      # @param {Any} key The key used on the cache
      # @param {Boolean} dump If is necessary to dump the Key
      # @param {Any} value The value of the cache
      def set(key, value, dump = true, options = {})
        #
        key = digest(key) if dump

        # If the driver has any namespace method or fixed value
        key = "#{namespace}/#{key}" if namespace?

        #
        _driver.set(key, value, options)
      end

      # Clear the full cache
      # @param {Hash} opts Options to use while clear the cache
      def clear(opts = nil)
        _driver.clear(opts)
      end

      # Check if there is namespace
      def namespace?
        !@namespace.nil?
      end

      # Get the namespace
      def namespace
        @namespace.respond_to(:call) ? @namespace.call : @namespace
      end

      private

      def _driver
        # Check if the driver was defined
        throw 'You have to define your cache driver before start using it' if driver.nil?

        # Return the driver
        driver
      end
    end
  end
end
