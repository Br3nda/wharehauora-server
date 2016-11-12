require 'rails_helper'
# rubocop:disable Rails/HttpPositionalArguments
RSpec.describe 'Homes' do
  include RequestApiSpecHelpers

  let(:home) { FactoryGirl.create(:home) }
  let(:data)   { JSON.parse(response.body).fetch('data') }
  let(:links)  { data['links'] }

  let(:valid_request_body) do
    {
      data: {
        type: 'homes',
        attributes: {
          name: home.name
        }
      }
    }
  end

  context '#index' do
    before { get '/api/homes', {}, jsonapi_request_headers }
    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'has data key' do
      verify_data_key_in_json response.body
    end

    it 'has no homes' do
      expect(data.length).to eq 0
    end

    it 'has one home' do
      home
      expect(data.length).to eq 0
    end
  end

  context '#show' do
    before do
      get  "/api/homes/#{home.id}", {}, jsonapi_request_headers
    end

    it 'responds with HTTP 200 status' do
      expect(response).to have_http_status(:ok)
    end

    it 'shows home data' do
      expect(data['id']).to eq(home.id.to_s)
      expect(data['attributes']['name']).to eq(home.name)
    end

    it 'has an owner' do
      expect(data['relationships']).to have_key('owner')
    end
  end

  context 'Update data' do
    it 'creates new home with a post' do
      post '/api/homes', valid_request_body.to_json, jsonapi_request_headers
      expect(response).to have_http_status(:created)
    end

    it 'modifies data with a put' do
      request_body = {
        data: {
          attributes: { name: 'New Name' },
          type: 'homes',
          id: home.id
        }
      }
      put "/api/homes/#{home.id}", request_body.to_json, jsonapi_request_headers
      expect(response).to have_http_status(:ok)
    end

    it 'deletes' do
      delete "/api/homes/#{home.id}", {}, jsonapi_request_headers
      expect(response).to have_http_status(204)
    end
  end
end
