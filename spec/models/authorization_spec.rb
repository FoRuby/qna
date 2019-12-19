require 'rails_helper'

RSpec.describe Authorization, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
  end
end
