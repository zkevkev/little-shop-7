require 'rails_helper'

RSpec.describe 'API Image Consistency', type: :request do
  it 'returns the same image URL' do
    response = HTTParty.get('https://api.example.com/image')
    expect(response['image_url']).to eq('https://expected.image/url.jpg')
  end
end