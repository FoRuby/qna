require 'rails_helper'

RSpec.describe Link, type: :model do

  context 'associations' do
    it { should belong_to(:linkable) }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
  end
end
