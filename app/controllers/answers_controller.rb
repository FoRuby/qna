class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[update destroy]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash[:success] = 'Answer successfully deleted.'
    end
    redirect_to question_path(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
