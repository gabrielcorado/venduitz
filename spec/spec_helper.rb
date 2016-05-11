# Include Venduitz
require 'venduitz'
require 'rack/test'

# Rspec conf
RSpec.configure do |config|
  config.order = 'random'
  config.seed = '12345'
  config.include Rack::Test::Methods
end

# Nested
class NestedView < Venduitz::View
  prop :kind
  prop :main, -> (o) { SubSampleView.generate(o.main) }
end

# Sub sample view
class SubSampleView < Venduitz::View
  prop :name
  prop :other
end

# Sample view
class SampleView < Venduitz::View
  # Define the property
  prop :kind
  prop :class, -> (o) { o.class }
  collection :subs, SubSampleView, exclude: [:other]
end

# Excluded SampleView

# Sample Class
class Sample
  #
  attr_accessor :subs, :main

  #
  def kind
    'Nice!'
  end
end

# Sub Sample class
class SubSample
  def name
    'Wow!'
  end

  def other
    'Here I come!'
  end
end
