object @comment
attributes :id, :body, :commentable_type, :commentable_id
node(:errors) { @comment.errors.full_messages }
