require 'rails_helper'

RSpec.describe Link, type: :model do

  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }

    context 'url' do
      it { should validate_presence_of :url }

      it { should_not allow_value('http:/foo.com/bar').for(:url) }
      it { should_not allow_value('ftp:/foo.com').for(:url) }
      it { should_not allow_value('http//foo.com').for(:url) }
      it { should allow_value('http://foo.com/blah_blah').for(:url) }
      it { should allow_value('https://foo.com/blah_blah').for(:url) }
    end
  end
end
