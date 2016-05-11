# Dependencies
require 'spec_helper'
require 'venduitz/grape'
require 'grape'

#
describe Venduitz::Grape do
  # Create a Grape APP
  let(:app) { Class.new(Grape::API) }

  # Define the app configs
  before do
    app.format :json
    app.formatter :json, Venduitz::Grape
  end

  #
  it 'should generate the response for the Grape endpoint' do
    # Generate the JSON object
    app.get('/venduitz', venduitz: SubSampleView) do
      # Return the proper object
      SubSample.new
    end

    # Execute it
    get '/venduitz'

    # Expectations
    expect(last_response.body).to eq("{\"name\":\"Wow!\",\"other\":\"Here I come!\"}")
  end
end
