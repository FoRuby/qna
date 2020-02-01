require 'rails_helper'
RSpec.describe SearchService do
  describe '.call' do
    describe 'search with SCOPE' do
      SearchService::SCOPES.each do |scope|
        it "#{scope}" do
          expect(ThinkingSphinx)
            .to receive(:search).with('foobar', classes: [scope.constantize])

          SearchService.call({ query: 'foobar', scope: scope })
        end
      end

      it 'All' do
        expect(ThinkingSphinx).to receive(:search).with('foobar')

        SearchService.call({ query: 'foobar', scope: '' })
      end
    end

    it 'search without search query' do
      expect(ThinkingSphinx).to receive(:search).with('', classes: [Question])
      SearchService.call({ query: '', scope: 'Question' })
    end

    it 'search with invalid SCOPE' do
      expect(ThinkingSphinx).to receive(:search).with('foobar')
      SearchService.call({ query: 'foobar', scope: 'InvalidScope' })
    end
  end
end
