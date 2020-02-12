require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    SearchService::SCOPES.each do |scope|
      it "call SearchService with params scope : #{scope}, query : 'foobar'" do
        expect(SearchService)
          .to receive(:call).with(query: 'foobar', scope: scope)

        get :search, params: { search: { query: 'foobar', scope: scope } }
      end
    end

    describe 'call SearchService with scope out of SCOPES list' do
      it "call SearchService with params scope : 'bar', query : 'foobar'" do
        expect(SearchService)
          .to receive(:call).with(query: 'foobar', scope: 'bar')

        get :search, params: { search: { query: 'foobar', scope: 'bar' } }
      end
    end
  end
end
