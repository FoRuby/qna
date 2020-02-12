require 'rails_helper'

RSpec.describe CommentHelper do
  let!(:question_comment) { create(:comment, commentable: create(:question)) }
  let!(:answer_comment) { create(:comment, commentable: create(:answer)) }

  describe '#comment_path' do
    it 'question_comment' do
      expect(helper.comment_path(question_comment))
        .to eq "/questions/#{question_comment.commentable.id}"
    end

    it 'answer_comment' do
      expect(helper.comment_path(answer_comment))
        .to eq "/questions/#{answer_comment.commentable.question.id}"
    end
  end
end
