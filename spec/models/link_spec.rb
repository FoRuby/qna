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

  describe 'scopes' do
    let!(:question) { create(:question) }
    let!(:link1) { create(:link, linkable: question) }
    let!(:link2) { create(:link, linkable: question) }
    let!(:link3) { create(:link, linkable: question) }

    context 'default scope by created_at: :asc' do
      subject { question.links.to_a }

      it { is_expected.to match_array [link1, link2, link3] }
    end
  end

  describe 'methods' do
    context '#gist?' do
      let(:gist) do
        create(:gist,
          name: 'Gist',
          url: 'https://gist.github.com/test/test',
          gist_body: 'GistBody',
        )
      end
      let(:link) { create(:link)}

      context 'gist' do
        subject { gist }
        it { is_expected.to be_gist }
      end

      context 'link' do
        subject { link }
        it { is_expected.not_to be_gist }
      end
    end
  end
end
