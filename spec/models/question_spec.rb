require 'rails_helper'

RSpec.describe Question, type: :model do

  context 'associations' do
    it { should have_many(:answers) }
  end

  context 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end
end
