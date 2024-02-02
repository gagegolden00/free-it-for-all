class Ipv4QuizUpdateService < ApplicationService
  def initialize(permitted_params: nil, quiz: nil)
    @permitted_params = permitted_params
    @quiz = quiz
  end

  def call
    if reconstructed_params?
      OpenStruct.new(success?: true, payload: @quiz)
    else
      OpenStruct.new(success?: false, payload: @quiz)
    end
  end

  private

  def reconstructed_params?
    build_quiz
  end

  def build_quiz
    return false unless @quiz.present?
    @quiz.attempts = @quiz.attempts += 1

    if @quiz.attempts >= @quiz.question_count
      @quiz.updateable = false
    end


  end
end
