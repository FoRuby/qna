shared_examples_for 'commentable' do
  describe 'associations' do
    it { should have_many(:comments).dependent(:destroy) }
  end
end
