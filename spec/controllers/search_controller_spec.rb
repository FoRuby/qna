require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    SearchService::SCOPES.reject { |item| item == 'All' }.each do |scope|
      context "search with scope #{scope}" do
        let(:scope) { scope }
        it_behaves_like 'Search'
      end
    end

    context 'search with scope All' do
      it 'calls search in All' do
        expect(ThinkingSphinx)
          .to receive(:search).with('foobar')
        get :search, params: { search_string: 'foobar', search_scope: 'All' }
      end

      it 'render search view' do
        get :search, params: { search_string: 'foobar', search_scope: 'All' }
        expect(response).to render_template :search
      end
    end

    describe 'search without search_string' do
      it 'does not call search' do
        expect(ThinkingSphinx).to_not receive(:search).with('')
        get :search, params: { search_string: '', search_scope: '' }
      end

      it 'redirect to questions' do
        get :search, params: { search_string: '', search_scope: '' }
        expect(response).to redirect_to questions_path
      end
    end

    describe 'search with invalid SCOPE' do
      it 'does not call search' do
        expect(ThinkingSphinx).to_not receive(:search).with('foobar')
        get :search, params: { search_string: '', search_scope: 'InvalidScope' }
      end

      it 'redirect to questions' do
        get :search, params: { search_string: '', search_scope: 'InvalidScope' }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
