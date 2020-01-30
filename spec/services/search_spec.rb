require 'rails_helper'
RSpec.describe SearchService do
  describe '.call' do
    let(:query) { 'foobar' }

    describe 'search with scope' do
      it 'Question' do
        expect(ThinkingSphinx).to receive(:search).with(query, classes: [Question])

        SearchService.call(query, 'Question')
      end

      it 'Answer' do
        expect(ThinkingSphinx).to receive(:search).with(query, classes: [Answer])

        SearchService.call(query, 'Answer')
      end

      it 'Comment' do
        expect(ThinkingSphinx).to receive(:search).with(query, classes: [Comment])

        SearchService.call(query, 'Comment')
      end

      it 'User' do
        expect(ThinkingSphinx).to receive(:search).with(query, classes: [User])

        SearchService.call(query, 'User')
      end

      it 'All' do
        expect(ThinkingSphinx).to receive(:search)

        SearchService.call(query, 'All')
      end
    end

    describe 'search without search_string' do
      it 'does not call search' do
        expect(ThinkingSphinx).to_not receive(:search)
        SearchService.call('', 'Question')
      end
    end

    describe 'search with invalid SCOPE' do
      it 'does not call search' do
        expect(ThinkingSphinx).to_not receive(:search).with(query)
        SearchService.call(query, 'InvalidScope')
      end
    end

    describe 'return results', js: true do
      let!(:question1) { create(:question, title: 'foobar') }
      let!(:question2) { create(:question, body: 'foobar') }
      let!(:comment1) { create(:comment, body: 'foobar', commentable: question2) }
      let!(:answer1) { create(:answer, body: 'foobar', question: question1) }
      let!(:user1) { create(:user, email: 'foobar@example.com') }

      before { ThinkingSphinx::Test.index }

      it 'return correct objects with Question scope' do
        ThinkingSphinx::Test.run do
          expect(SearchService.call('foobar', 'Question'))
            .to match_array [question1, question2]
        end
      end

      it 'return correct objects with All scope' do
        ThinkingSphinx::Test.run do
          expect(SearchService.call('foobar', 'All'))
            .to match_array [question1, question2, comment1, answer1, user1]
        end
      end
    end
  end
end
