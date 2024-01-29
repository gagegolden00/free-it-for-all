class Ipv4QuizzesController < ApplicationController
  def new
    @quiz = Ipv4Quiz.new()
    authorize @quiz
  end

  def create
    authorize current_user
    @quiz = Ipv4Quiz.new(permitted_params)
    @quiz.user = current_user

    if @quiz.save
      redirect_to edit_ipv4_quiz_path(@quiz)
    else
      redirect_to new_ipv4_quiz_path
      flash.notice = "Oops, something went wrong"
    end
  end

  def edit
    @quiz = Ipv4Quiz.find(params[:id])
    authorize @quiz
  end

  def update
    @quiz = Ipv4Quiz.find(params[:id])
    authorize @quiz
  end

  def show
    @quiz = Ipv4Quiz.find(params[:id])
    authorize @quiz
  end

  def index
    @quizzes = policy_scope(Ipv4Quiz.all)
  end

  def destroy
    @quiz = Ipv4Quiz.find(params[:id])
    authorize @quiz
  end


  private

  def permitted_params
    params.require(:ipv4_quiz).permit(:question_count)
  end

end
