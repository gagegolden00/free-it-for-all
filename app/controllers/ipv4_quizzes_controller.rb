class Ipv4QuizzesController < ApplicationController
  def new
    @quiz = Ipv4Quiz.new()
    authorize @quiz
  end

  def create
    @quiz = Ipv4Quiz.new(permitted_params)
    authorize @quiz
    @quiz.user = current_user
    @quiz.quiz_number = @quiz.user.ipv4_quizzes.count + 1
    if @quiz.save
      redirect_to edit_ipv4_quiz_path(@quiz)
    else
      redirect_to new_ipv4_quiz_path
      flash.notice = "Oops, something went wrong"
    end
  end

  def edit
    @quiz = Ipv4Quiz.find(params[:id])
    @quiz_number = @quiz.quiz_number
    @question_count = @quiz.question_count
    @quiz_correct_count = @quiz.correct_count || 0
    @quiz_incorrect_count = @quiz.incorrect_count || 0
    @attempts = @quiz_correct_count + @quiz_incorrect_count
    @random_ipv4_address = "#{rand(0..155)}.#{rand(0..155)}.#{rand(0..155)}.#{rand(0..155)}"
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
