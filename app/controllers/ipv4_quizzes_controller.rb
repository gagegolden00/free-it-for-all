class Ipv4QuizzesController < ApplicationController
  def new; end

  def create

    @quiz = Ipv4Quiz.new(permitted_params)
    @quiz.user = current_user

    if @quiz.save!
      redirect_to edit_ipv4_quiz_path(@quiz)
    else
      redirect_to new_ipv4_quiz_path
      flash.notice = "Oops, something went wrong"
    end

  end

  def update; end

  def show; end

  def index; end


  private

  def permitted_params
    params.require(:ipv4_quiz).permit(:question_count)
  end
end
