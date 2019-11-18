require 'rails_helper'

RSpec.describe Question, type: :model do

  context 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
