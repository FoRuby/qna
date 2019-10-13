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

  describe '#author?(item)' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:item_without_author) { Class.new }

    context 'author' do
      subject { author }
        it { is_expected.to be_an_author_of(question) }
        it { is_expected.to_not be_an_author_of(item_without_author) }
    end

    context 'not_author' do
      subject { not_author }
        it { is_expected.to_not be_an_author_of(question) }
        it { is_expected.to_not be_an_author_of(item_without_author) }
    end
  end
end
