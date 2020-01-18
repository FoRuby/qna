class Api::V1::AnswersController < Api::V1::BaseController
  skip_authorization_check

  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show update destroy]

  def index
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersListSerializer
  end

  def show
    render json: @answer
  end

  def create
    @answer = current_resource_owner.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize! :update, @answer

    if @answer.update(answer_params)
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer

    @answer.destroy
    render json: { messages: ['Answer was successfully deleted.'] }
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
