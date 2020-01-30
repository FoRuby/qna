require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    SearchService::SCOPES.each do |scope|
      let!(:params) do
        { serach: { query: 'foobar', scope: scope } }
      end

      it "call SearchService with params scope : #{scope}, query : 'foobar'" do
        expect(SearchService).to receive(:call).with(params[:search])

        get :search, params: params
      end
    end

    describe 'call SearchService with scope out of SCOPES list' do
      let!(:params) do
        { serach: { query: 'foobar', scope: 'bar' } }
      end

      it "call SearchService with params scope : 'bar', query : 'foobar'" do
        expect(SearchService).to receive(:call).with(params[:search])

        get :search, params: params
      end
    end
  end
end
