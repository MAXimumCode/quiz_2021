require "rexml/document"
require_relative "question"

class Quiz
  attr_reader :questions,
              :score,
              :right_question,
              :answer_time

  def self.load_from_xml(file_name)
    file = File.new(file_name)
    doc = REXML::Document.new(file)
    file.close

    questions = doc.get_elements("questions/question").map do |item|
      data = {}
      data[:question] = item.text("text")
      data[:answers] = item.get_elements("variants/variant").map(&:text)
      data[:timeout] = item.attributes["minutes"].to_f
      data[:points] = item.attributes["points"].to_i
      item.elements.each("variants/variant") do |variant|
        data[:correct_answer] = variant.text if variant.attributes["right"] == "true"
      end

      Question.new(data)
    end
    new(questions)
  end

  def initialize(questions)
    @questions = questions
    @score = 0
    @right_question = 0
    @answer_time = 0
    @question_time_begin = Time.now
    @num_current_question = 0
  end

  def current_question
    questions[@num_current_question]
  end

  def next_question
    @num_current_question += 1
  end

  def seconds_to_answer
    current_question.timeout
  end

  def correct_answer
    current_question.correct_answer
  end

  def answer_correct?(user_answer)
    correct_answer == user_answer
  end

  def in_progress?
    @num_current_question < questions.size
  end

  def user_answer(user_input)
    @answer_time = Time.now - @question_time_begin
    @question_time_begin = Time.now

    if answer_correct?(user_input) && @answer_time < seconds_to_answer
      @score += current_question.points
      @right_question += 1
      :correct
    elsif @answer_time > seconds_to_answer
      :timeout
    end
  end
end
