shared_examples_for 'voted' do

  let!(:model) { described_class.controller_name.classify.constantize }
  let!(:votable) { create(model.to_s.underscore.to_sym) }
  let!(:voter) { create(:user) }
  let!(:authored) { create(model.to_s.underscore.to_sym, user: voter) }

  describe 'PATCH #vote' do
    context 'Not an votable author' do
      before { login(voter) }

      it 'assigns the requested resource to @votable' do
        patch :vote, params: { id: votable, value: 1 }
        expect(assigns(:votable)).to eq votable
      end

      it 'set new vote up' do
        expect {
          patch :vote, params: { id: votable, value: 1, format: :json }
        }.to change { votable.rating }.by(1)
      end

      it 'tries to vote twice' do
        patch :vote, params: { id: votable }
        expect {
          patch :vote, params: { id: votable, format: :json }
        }.to_not change { votable.rating }
      end

      it 'render vote.rabl' do
        patch :vote, params: { id: votable, value: 1, format: :json }
        expect(response).to render_template :vote
      end
    end

    context 'Votable author' do
      before { login(voter) }

      it 'tries to set vote up' do
        expect {
          patch :vote, params: { id: authored, value: 1, format: :json }
        }.to_not change { votable.rating }
      end

      it 'returns error response' do
        patch :vote, params: { id: authored, value: 1, format: :json }
        expect(response.status).to eq 403

        parse_json = JSON(response.body)
        expect(parse_json['errorMessages'])
          .to eq ["User сan't vote for his own #{authored.class}"]
      end
    end

    context 'Unauthorized user' do
      it 'tries to set vote up' do
        expect {
          patch :vote, params: { id: votable, format: :json }
        }.to_not change { votable.rating }
      end

      it 'returns error response' do
        patch :vote, params: { id: votable, format: :json }
        expect(response.status).to eq 401
        parse_json = JSON(response.body)
        expect(parse_json['error'])
          .to eq 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
