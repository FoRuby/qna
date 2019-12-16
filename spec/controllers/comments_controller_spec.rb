require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:comment_author) { create(:user) }

  describe 'POST #create' do
    context 'Question' do
      context 'Authorized user' do
        before { login(comment_author) }

        context 'with valid attributes' do
          it 'save new comment in DB' do
            expect {
              post :create, params: {
                question_id: question,
                context: 'question',
                comment: attributes_for(:comment),
                format: :js
              }
            }.to change(Comment, :count).by(1)
          end

          it 'check @comment.commentable is a assigned question' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(assigns(:comment).commentable).to eq(question)
          end

          it 'check @comment.user is a comment_author' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(assigns(:comment).user).to eq(comment_author)
          end

          it 'render create' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect {
              post :create, params: {
                question_id: question,
                context: 'question',
                comment: attributes_for(:comment, :invalid_comment),
                format: :js
              }
            }.to_not change(Comment, :count)
          end

          it 'render create' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment, :invalid_comment),
              format: :js
            }

            expect(response).to render_template :create
          end
        end
      end

      context 'Unauthorized user' do
        context 'with valid attributes' do
          it 'does not save new comment in DB' do
            expect {
              post :create, params: {
                question_id: question,
                context: 'question',
                comment: attributes_for(:comment),
                format: :js
              }
            }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response).to_not render_template :create
          end

          it 'response status 401' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response.status).to eq 401
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect {
              post :create, params: {
                question_id: question,
                context: 'question',
                comment: attributes_for(:comment, :invalid_comment),
                format: :js
              }
            }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment, :invalid_comment),
              format: :js
            }

            expect(response).to_not render_template :create
          end

          it 'response status 401' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response.status).to eq 401
          end
        end
      end
    end

    context 'Answer' do
      context 'Authorized user' do
        before { login(comment_author) }

        context 'with valid attributes' do
          it 'save new comment in DB' do
            expect {
              post :create, params: {
                answer_id: answer,
                context: 'answer',
                comment: attributes_for(:comment),
                format: :js
              }
            }.to change(Comment, :count).by(1)
          end

          it 'check @comment.commentable is a assigned question' do
            post :create, params: {
              answer_id: answer,
              context: 'answer',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(assigns(:comment).commentable).to eq(answer)
          end

          it 'check @comment.user is a comment_author' do
            post :create, params: {
              answer_id: answer,
              context: 'answer',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(assigns(:comment).user).to eq(comment_author)
          end

          it 'render create' do
            post :create, params: {
              answer_id: answer,
              context: 'answer',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect {
              post :create, params: {
                answer_id: answer,
                context: 'answer',
                comment: attributes_for(:comment, :invalid_comment),
                format: :js
              }
            }.to_not change(Comment, :count)
          end

          it 'render create' do
            post :create, params: {
              answer_id: answer,
              context: 'answer',
              comment: attributes_for(:comment, :invalid_comment),
              format: :js
            }

            expect(response).to render_template :create
          end
        end
      end

      context 'Unauthorized user' do
        context 'with valid attributes' do
          it 'does not save new comment in DB' do
            expect {
              post :create, params: {
                answer_id: answer,
                context: 'answer',
                comment: attributes_for(:comment),
                format: :js
              }
            }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: {
              answer_id: answer,
              context: 'answer',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response).to_not render_template :create
          end

          it 'response status 401' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response.status).to eq 401
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect {
              post :create, params: {
                answer_id: answer,
                context: 'answer',
                comment: attributes_for(:comment, :invalid_comment),
                format: :js
              }
            }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: {
              answer_id: answer,
              context: 'answer',
              comment: attributes_for(:comment, :invalid_comment),
              format: :js
            }

            expect(response).to_not render_template :create
          end

          it 'response status 401' do
            post :create, params: {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment),
              format: :js
            }

            expect(response.status).to eq 401
          end
        end
      end
    end
  end
end
