require 'rails_helper'

RSpec.describe 'Image presence on every page', type: :feature do
  let(:expected_img_src) { 'https://expected.image/url.jpg' }

  it 'has the API image on every page' do
    paths = [merchants_path, admin_invoices_path, admin_merchants_path] 

    paths.each do |path|
      visit path
      expect(page).to have_selector("img[src='#{expected_img_src}']")
    end
  end
end
