class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  before_action :set_answer, only: %i[update destroy mark_best]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
    flash.now[:success] = 'Answer successfully created.'
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      flash.now[:success] = 'Answer successfully edited.'
    end
  end

  def mark_best
    if current_user.author?(@answer.question)
      unless @answer.valid?(:already_best)
        @answer.mark_as_best!
        flash.now[:success] = 'Best answer selected.'
      end
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash.now[:success] = 'Answer successfully deleted.'
    end
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
