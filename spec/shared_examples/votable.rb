require 'rails_helper'

RSpec.shared_examples 'votable' do

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'methods' do
    let(:votable) { create(described_class.to_s.underscore.to_sym) }
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    context '#vote_up' do
      context 'tries to vote up' do
        it 'create new Vote' do
          expect { votable.vote_up(user) }.to change(Vote, :count).by(1)
        end

        it 'assign created Vote attributes' do
          votable.vote_up(user)

          expect(Vote.last.value).to eq 1
          expect(Vote.last.user).to eq user
          expect(Vote.last.votable).to eq votable
        end
      end

      context 'tries to vote up twice' do
        it 'does not change votable rating' do
          votable.vote_up(user)
          votable.vote_up(user)

          expect(votable.rating).to eq 1
        end
      end
    end

    context '#vote_down' do
      context 'tries to vote down' do
        it 'create new Vote' do
          expect { votable.vote_up(user) }.to change(Vote, :count).by(1)
        end

        it 'assign created Vote attributes' do
          votable.vote_down(user)

          expect(Vote.last.value).to eq -1
          expect(Vote.last.user).to eq user
          expect(Vote.last.votable).to eq votable
        end
      end

      context 'tries to vote up twice' do
        it 'does not change votable rating' do
          votable.vote_down(user)
          votable.vote_down(user)

          expect(votable.rating).to eq -1
        end
      end
    end

    context '#cancel_vote_of' do
      before do
        votable.vote_up(user)
        votable.cancel_vote_of(user)
      end

      it 'tries to cancel vote of' do
        expect(votable.rating).to eq 0
        expect(votable).to_not be_vote_of(user)
      end
    end

    context '#rating' do
      before do
        votable.vote_up(user)
        votable.vote_up(another_user)
      end

      it 'votable rating after 2 votes' do
        expect(votable.rating).to eq 2
      end
    end

    context '#vote_of?' do
      context 'true if resource has vote from user' do
        before { votable.vote_up(user) }

        subject { votable }
        it { is_expected.to be_vote_of(user) }
      end

      context 'false if resource has no vote from user' do
        subject { votable }
        it { is_expected.to_not be_vote_of(another_user) }
      end
    end
  end
end
