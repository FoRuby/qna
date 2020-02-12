shared_examples_for 'votable' do

  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'methods' do
    let(:votable) { create(described_class.to_s.underscore.to_sym) }

    let(:user) { create(:user) }
    let(:vote_up) { build(:vote, user: user, votable: votable, value: 1) }
    let(:vote_down) { build(:vote, user: user, votable: votable, value: -1) }
    let(:cancel_vote) { build(:vote, user: user, votable: votable, value: 0) }

    context '#vote_by' do
      context 'tries to vote up' do
        it 'create new Vote' do
          expect { votable.vote_by(vote_up) }.to change(Vote, :count).by(1)
        end

        it 'assign created Vote attributes' do
          votable.vote_by(vote_up)

          expect(Vote.last.value).to eq 1
          expect(Vote.last.user).to eq user
          expect(Vote.last.votable).to eq votable
        end

        it 'does not change votable rating after second vote up' do
          votable.vote_by(vote_up)
          votable.vote_by(vote_up)

          expect(votable.rating).to eq 1
        end
      end

      context 'tries to vote down' do
        it 'create new Vote' do
          expect { votable.vote_by(vote_up) }.to change(Vote, :count).by(1)
        end

        it 'assign created Vote attributes' do
          votable.vote_by(vote_down)

          expect(Vote.last.value).to eq -1
          expect(Vote.last.user).to eq user
          expect(Vote.last.votable).to eq votable
        end

        it 'does not change votable rating after second vote down' do
          votable.vote_by(vote_down)
          votable.vote_by(vote_down)

          expect(votable.rating).to eq -1
        end
      end

      context 'tries to cancel vote' do
        it 'create new Vote' do
          expect { votable.vote_by(vote_up) }.to change(Vote, :count).by(1)
        end

        it 'assign created Vote attributes' do
          votable.vote_by(cancel_vote)

          expect(Vote.last.value).to eq 0
          expect(Vote.last.user).to eq user
          expect(Vote.last.votable).to eq votable
        end

        it 'does not change votable rating after second vote down' do
          votable.vote_by(cancel_vote)
          votable.vote_by(cancel_vote)

          expect(votable.rating).to eq 0
        end
      end

      context 'tries to change vote' do
        before { votable.vote_by(vote_up) }

        it 'does not create new Vote' do
          expect { votable.vote_by(vote_down) }.to_not change(Vote, :count)
        end

        it 'update Vote attributes' do
          votable.vote_by(vote_down)

          expect(Vote.last.value).to eq -1
          expect(Vote.last.user).to eq user
          expect(Vote.last.votable).to eq votable
        end

        it 'does not change votable rating after second vote down' do
          votable.vote_by(vote_down)

          expect(votable.rating).to eq -1
        end
      end
    end

    context '#rating' do
      let(:another_user) { create(:user) }
      let(:another_user_vote_up) { build(:vote, user: another_user, votable: votable, value: 1) }
      let(:another_user_vote_down) { build(:vote, user: another_user, votable: votable, value: -1) }
      let(:another_user_cancel_vote) { build(:vote, user: another_user, votable: votable, value: 0) }

      it 'votable rating after 2 votes up' do
        votable.vote_by(vote_up)
        votable.vote_by(another_user_vote_up)

        expect(votable.rating).to eq 2
      end

      it 'votable rating after 2 votes down' do
        votable.vote_by(vote_down)
        votable.vote_by(another_user_vote_down)

        expect(votable.rating).to eq -2
      end

      it 'votable rating after 1 votes down and 1 votes up' do
        votable.vote_by(vote_down)
        votable.vote_by(another_user_vote_up)

        expect(votable.rating).to eq 0
      end
    end
  end
end
