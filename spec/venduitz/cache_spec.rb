# Include the helper
require 'spec_helper'

# Define a simple cache driver
class CacheDriver
  # Define the storage
  attr_reader :storage

  # Init!
  def initialize
    # Initialize the storage
    @storage = {}
  end

  #
  def exist?(key)
    @storage.key?(key)
  end

  #
  def set(key, value, options = {})
    @storage[key] = value
  end

  #
  def get(key)
    @storage[key]
  end

  #
  def clear(options = nil)
    @storage = {}
  end
end

# Cache object tes
class CacheSample < SubSample
  #
  attr_reader :other

  # Init!
  def initialize(time)
    @other = time
  end
end

# Set the driver to the Venduitz
Venduitz::Cache.driver = CacheDriver.new

#
describe Venduitz::Cache do
  #
  before(:each) do
    # Clear the cache
    Venduitz::Cache.clear
  end

  #
  it 'should set/get a cache withoud digest' do
    # Set the cache (withoud digest)
    Venduitz::Cache.set 'hello', 'here', false

    # Assertions
    expect(Venduitz::Cache.exist?('hello')).to eq(true)
    expect(Venduitz::Cache.get('hello')).to eq('here')
  end

  #
  it 'should set/get a cache withoud digest' do
    # Set the cache (withoud digest)
    Venduitz::Cache.set 'hello', 'here'

    # Get the digested key
    key = Venduitz::Cache.digest 'hello'

    # Get it
    expect(Venduitz::Cache.get(key)).to eq('here')
  end

  #
  it 'should generate a view with cache' do
    # Get the time now and save it
    time = Time.now

    # Gen the JSON
    res = [SubSampleView.to_json(CacheSample.new(time), [], true)]

    # Generate it again
    res += [SubSampleView.to_json(CacheSample.new(time), [], true)]

    # Check Cache entries
    expect(Venduitz::Cache.driver.storage.keys.size).to eq(1)
    expect(Venduitz::Cache.get(Venduitz::Cache.driver.storage.keys[0])).to eq(res[0])
  end
end
