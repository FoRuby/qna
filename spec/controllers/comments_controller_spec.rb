require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:comment_author) { create(:user) }

  describe 'POST #create' do
    context 'Question' do
      context 'with valid attributes' do
        let(:params) do
          {
            question_id: question,
            context: 'question',
            comment: attributes_for(:comment),
            format: :js
          }
        end

        context 'authorized user' do
          before { login(comment_author) }

          it 'save new comment in DB' do
            expect{ post :create, params: params }
              .to change(Comment, :count).by(1)
          end

          it 'check @comment.commentable is a assigned question' do
            post :create, params: params

            expect(assigns(:comment).commentable).to eq(question)
          end

          it 'check @comment.user is a comment_author' do
            post :create, params: params

            expect(assigns(:comment).user).to eq(comment_author)
          end

          it 'render create' do
            post :create, params: params

            expect(response).to render_template :create
          end

          it 'returns status :ok' do
            post :create, params: params

            expect(response).to have_http_status(:ok)
          end
        end

        context 'unauthorized user' do
          let(:params) do
            {
              question_id: question,
              context: 'question',
              comment: attributes_for(:comment, :invalid_comment),
              format: :js
            }
          end

          it 'does not save new comment in DB' do
            expect{ post :create, params: params }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: params

            expect(response).to_not render_template :create
          end

          it 'returns status :unauthorized' do
            post :create, params: params

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            question_id: question,
            context: 'question',
            comment: attributes_for(:comment, :invalid_comment),
            format: :js
          }
        end

        context 'authorized user' do
          before { login(comment_author) }

          it 'does not save the comment' do
            expect{ post :create, params: params }.to_not change(Comment, :count)
          end

          it 'render create' do
            post :create, params: params

            expect(response).to render_template :create
          end

          it 'returns status :ok' do
            post :create, params: params

            expect(response).to have_http_status(:ok)
          end
        end

        context 'unauthorized user' do
          it 'does not save the comment' do
            expect{ post :create, params: params }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: params

            expect(response).to_not render_template :create
          end

          it 'returns status :unauthorized' do
            post :create, params: params

            expect(response).to have_http_status(:unauthorized)
          end

        end
      end
    end

    context 'Answer' do
      context 'with valid attributes' do
        let(:params) do
          {
            answer_id: answer,
            context: 'answer',
            comment: attributes_for(:comment),
            format: :js
          }
        end

        context 'authorized user' do
          before { login(comment_author) }

          it 'save new comment in DB' do
            expect{ post :create, params: params }
              .to change(Comment, :count).by(1)
          end

          it 'check @comment.commentable is a assigned question' do
            post :create, params: params

            expect(assigns(:comment).commentable).to eq(answer)
          end

          it 'check @comment.user is a comment_author' do
            post :create, params: params

            expect(assigns(:comment).user).to eq(comment_author)
          end

          it 'render create' do
            post :create, params: params

            expect(response).to render_template :create
          end

          it 'returns status :ok' do
            post :create, params: params

            expect(response).to have_http_status(:ok)
          end
        end

        context 'unauthorized user' do
          it 'does not save new comment in DB' do
            expect{ post :create, params: params }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: params

            expect(response).to_not render_template :create
          end

          it 'returns status :unauthorized' do
            post :create, params: params

            expect(response).to have_http_status(:unauthorized)
          end

        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            answer_id: answer,
            context: 'answer',
            comment: attributes_for(:comment, :invalid_comment),
            format: :js
          }
        end

        context 'authorized user' do
          before { login(comment_author) }

          it 'does not save the comment' do
            expect{ post :create, params: params }.to_not change(Comment, :count)
          end

          it 'render create' do
            post :create, params: params

            expect(response).to render_template :create
          end

          it 'returns status :ok' do
            post :create, params: params

            expect(response).to have_http_status(:ok)
          end
        end

        context 'unauthorized user' do
          it 'does not save the comment' do
            expect{ post :create, params: params }.to_not change(Comment, :count)
          end

          it 'does not render create' do
            post :create, params: params

            expect(response).to_not render_template :create
          end

          it 'returns status :unauthorized' do
            post :create, params: params

            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
