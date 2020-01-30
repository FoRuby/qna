require 'rails_helper'
RSpec.describe SearchService do
  describe '.call' do
    let(:search_string) { 'search_string' }

    describe 'search with scopes' do
      SearchService::SCOPES.each do |search_scope|
        it "calls search in #{search_scope}" do
          expect(ThinkingSphinx).to receive(:search).with(
            search_string,
            classes: [search_scope.classify.constantize]
          )

          SearchService.call(search_string, search_scope)
        end
      end
    end

    describe 'search without scopes' do
      it 'calls search in all' do
        expect(ThinkingSphinx).to receive(:search).with(search_string)
        SearchService.call(search_string, '')
      end
    end

    describe 'search with invalid SCOPE' do
      it 'calls search in all' do
        expect(ThinkingSphinx).to_not receive(:search).with(search_string)
        SearchService.call(search_string, 'InvalidScope')
      end
    end
  end
end
