# frozen_string_literal: true

require 'rails_helper'
require 'google/apis/civicinfo_v2'
describe Representative do 
  subject(:representatives) { described_class.civic_api_to_representative_params(result) }
  before do 
    url =
      'https://civicinfo.googleapis.com/civicinfo/v2/representatives?address=4020%20Ashby%20Ln%20Indian%20Land%20SC%2029707&key=google-api-key'
    json = File.read(Rails.root.join('fixtures/representatives.json'))
    stub_request(:get, url).to_return(body: json, status: 200, headers: { content_type: 'application/json' })
  end

  let(:address) { '4020 Ashby Ln Indian Land SC 29707' }
  let(:service) do
    s = Google::Apis::CivicinfoV2::CivicInfoService.new
    s.key = 'google-api-key'
    s
  end
  let(:result) { service.representative_info_by_address(address: address) }

  describe '#civic_api_to_representative_params' do
    before { described_class.create!({name: 'Joseph R. Biden'}) }

    it 'does not add a duplicate representative to reps list' do
      expect { representatives }.to change(described_class, :count).by(20)
    end
  end
end
