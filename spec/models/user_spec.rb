require 'rails_helper'

RSpec.describe User, type: :model do

  context 'associations' do
    it { should have_many(:answers) }
    it { should have_many(:questions) }
  end

  context 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }

    it { should validate_length_of(:password).is_at_least(6) }
    it { should have_db_index(:email).unique(:true) }
  end

  context 'methods' do
    context '.author?(item)' do
      let(:author) { create(:user) }
      let(:not_author) { create(:user) }
      let(:question) { create(:question, user: author) }
      let(:answer) { create(:answer, question: question, user: author) }
      let(:item_without_author) { Class.new }

      it 'author.author?(question) should be true' do
        expect(author.author?(answer)).to be true
      end

      it 'author.author?(answer) should be true' do
        expect(author.author?(answer)).to be true
      end

      it 'not_author.author?(question) should be false' do
        expect(not_author.author?(answer)).to be false
      end

      it 'not_author.author?(answer) should be false' do
        expect(not_author.author?(answer)).to be false
      end

      it 'author.author?(item_without_author) should be false' do
        expect(author.author?(item_without_author)).to be false
      end
    end
  end
end
