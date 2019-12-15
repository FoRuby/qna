require 'rails_helper'

RSpec.describe Comment, type: :model do

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :body }
    it { should validate_presence_of :commentable }
  end
end
