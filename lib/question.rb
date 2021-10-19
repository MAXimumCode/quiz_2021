class Question
  attr_reader :question,
              :answers,
              :correct_answer,
              :timeout,
              :points

  def initialize(params)
    @question = params.fetch(:question)
    @answers = params.fetch(:answers).shuffle
    @correct_answer = params.fetch(:correct_answer)
    @timeout = params.fetch(:timeout) * 60
    @points = params.fetch(:points)
  end

  def to_s
    list = answers.map.with_index { |a, i| "#{i + 1}. #{a}" }.join("\n")
    <<~TO_S

      #{question} (#{points} баллов)

      Варианты ответов:
      #{list}

      У Вас есть #{timeout.round(0)} секунд.

    TO_S
  end
end
