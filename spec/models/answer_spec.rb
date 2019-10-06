require 'rails_helper'

RSpec.describe Answer, type: :model do

  context 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:author) }
  end

  context 'validations' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :author }
  end
end
