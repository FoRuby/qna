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

    context 'default scope by created_at: :asc' do
      subject { question.links.to_a }

      it { is_expected.to match_array [link1, link2] }
    end
  end

  describe 'callbacks' do
    it { should callback(:save_gist_body!).after(:create).if(:gist?) }

    let(:gist) do
      Link.create(
        name: 'Gist',
        url: 'https://gist.github.com/FoRuby/f7059ba947b5d0138f302f8e43694348',
        linkable: create(:question)
      )
    end
    let(:link) { create(:link) }

    context 'if link url = gist url => link.gist_body', :vcr do
      subject { gist.gist_body }
      it { is_expected.to eq('GistTitle') }
    end

    context 'if link url != gist url => link.gist_body' do
      subject { link.gist_body }
      it { is_expected.to be_nil }
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

      context 'gist', :vcr do
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
