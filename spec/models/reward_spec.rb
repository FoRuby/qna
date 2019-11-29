require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
    it { should belong_to(:question) }

    context 'have one attached files' do
      subject { Reward.new.image }
      it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }
    end
  end

  describe 'validations' do
    it { should validate_presence_of :title }
  end
end
