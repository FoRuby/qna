class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new

    @new_link = Link.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      flash[:success] = 'Your question successfully created.'
      redirect_to @question
    end
  end

  def update
    if current_user.author?(@question)
      @question.update(question_params)
      flash.now[:success] = 'Question successfully edited.'
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:success] = 'Question successfully deleted.'
      redirect_to questions_path
    else
      redirect_to question_path(@question)
      flash[:success] = 'You can only delete your question.'
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:name, :url]
    )
  end
end
