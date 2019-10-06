require 'rails_helper'

RSpec.describe Question, type: :model do

  context 'associations' do
    it { should have_many(:answers) }
    it { should belong_to(:author) }
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :author }
  end
end
