require 'rails_helper'

describe Representative do 
  describe '.civic_api_to_representative_params' do
    let(:mock_rep) do
      OpenStruct.new({
        officials: [OpenStruct.new({ name: 'Riya Sheik' })],
        offices: [OpenStruct.new({ name: 'Mayor', division_id: 'mock_division_id', official_indices: [0] })]
      })
    end

    it 'does not add a duplicate representative to reps list' do
      #creates the first representative 
      Representative.civic_api_to_representative_params(mock_rep)
      expect {
        #attempts to add the same representative again
        Representative.civic_api_to_representative_params(mock_rep)
      }.not_to change {Representative.count}
    end
  end
end