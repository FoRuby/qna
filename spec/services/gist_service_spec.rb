require 'rails_helper'

RSpec.describe GistService, :vcr do
  let(:valid_gist_url) { 'https://gist.github.com/FoRuby/f7059ba947b5d0138f302f8e43694348' }
  let(:invalid_gist_url) { 'https://gist.github.com/FoRuby/f7059ba947b5d01' }

  describe '#call GistService' do
    context 'when gist url valid' do
      subject { GistService.new(valid_gist_url).call }

      it { is_expected.to eq 'GistTitle' }
    end

    context 'when gist url invalid' do
      subject { GistService.new(invalid_gist_url).call }

      it { is_expected.to be_nil }
    end
  end
end
