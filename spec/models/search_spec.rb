require 'rails_helper'

RSpec.describe Search, type: :sphinx do

  describe 'scan' do
    it "return search_types" do
      expect(described_class::CONTEXTS).to eq %w(Questions  Answers  Comments  Users)
    end

    it 'should return nil if empty query' do
     expect(Search.scan(' ', 'Questions')).to be_nil
    end
    
    it 'receive data' do
      query = "lalala"
      data = ThinkingSphinx::Query.escape(query)
      expect(ThinkingSphinx::Query).to receive(:escape).with(query).and_call_original
      expect(ThinkingSphinx).to receive(:search).with(data)
      Search.scan(query, "")
    end
  end
end