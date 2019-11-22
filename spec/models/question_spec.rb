require 'rails_helper'

RSpec.describe Question, type: :model do

  context 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should belong_to(:user) }

    it 'have many attached files' do
      expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  context 'nested attributes' do
    it { should accept_nested_attributes_for :links }
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe '#files' do
    let(:question) { create(:question) }

    before do
      question.files.attach(
        io: File.open("#{Rails.root}/spec/fixtures/files/image1.jpg"),
        filename: 'image1.jpg'
      )
      question.files.attach(
        io: File.open("#{Rails.root}/spec/fixtures/files/image2.jpg"),
        filename: 'image2.jpg'
      )
    end

    subject { question.files }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::Many) }
  end
end
