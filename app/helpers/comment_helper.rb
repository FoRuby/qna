module CommentHelper
  def comment_path(comment)
    question = comment.commentable
    question = comment.commentable.question if question.is_a? Answer

    question_path(question)
  end
end
