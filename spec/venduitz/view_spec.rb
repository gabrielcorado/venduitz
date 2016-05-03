# Include the helper
require 'spec_helper'

# Nested
class NestedView < Venduitz::View
  prop :kind
  prop :main, -> (o) { SubSampleView.generate(o.main) }
end

# Sub sample view
class SubSampleView < Venduitz::View
  prop :name
end

# Sample view
class SampleView < Venduitz::View
  # Define the property
  prop :kind
  prop :class, -> (o) { o.class }
  collection :subs, SubSampleView
end

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
end

#
describe Venduitz::View do
  #
  it 'should define the properties' do
    expect(SampleView.props[:kind]).to eq(:kind)
    expect(SampleView.props[:class]).to be_a(Proc)
  end

  #
  it 'should define the collections' do
    expect(SampleView.collects[:subs][:view]).to eq(SubSampleView)
    expect(SampleView.collects[:subs][:value]).to eq(:subs)
  end

  #
  it 'should generate the JSON of a simple view' do
    # Generate the JSON object
    res = SubSampleView.to_json(SubSample.new)

    # Expectations
    expect(res).to eq("{\"name\":\"Wow!\"}")
  end

  #
  it 'should generate the JSON of a compund view' do
    # Initialize the object
    obj = Sample.new

    # Add a sub object
    obj.subs = [SubSample.new]

    # Generate the JSON object
    res = SampleView.to_json(obj)

    # Expectations
    expect(res).to eq("{\"kind\":\"Nice!\",\"class\":\"Sample\",\"subs\":[\"{\\\"name\\\":\\\"Wow!\\\"}\"]}")
  end

  #
  context 'nested' do
    #
    it 'should generate the JSON of a simple view' do
      # Initialize the object
      obj = Sample.new

      # Add a sub object
      obj.main = SubSample.new

      # Generate the JSON object
      res = NestedView.to_json(obj)

      # Expectations
      expect(res).to eq("{\"kind\":\"Nice!\",\"main\":{\"name\":\"Wow!\"}}")
    end
  end
end
