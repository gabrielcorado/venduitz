# Include the helper
require 'spec_helper'

#
describe Venduitz::View do
  #
  let(:obj) { Sample.new }
  let(:sub_obj) { o = Sample.new; o.subs = [SubSample.new]; o }

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
    expect(res).to eq("{\"name\":\"Wow!\",\"other\":\"Here I come!\"}")
  end

  #
  it 'should exclude values from the view' do
    # Gen the JSON
    res = SubSampleView.to_json(SubSample.new, [:other])

    # Expectations
    expect(res).to eq("{\"name\":\"Wow!\"}")
  end

  #
  it 'should generate the JSON of a compund view' do
    # Generate the JSON object
    res = SampleView.to_json(sub_obj)

    # Expectations
    expect(res).to eq("{\"kind\":\"Nice!\",\"class\":\"Sample\",\"subs\":[{\"name\":\"Wow!\"}]}")
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
      expect(res).to eq("{\"kind\":\"Nice!\",\"main\":{\"name\":\"Wow!\",\"other\":\"Here I come!\"}}")
    end
  end
end
