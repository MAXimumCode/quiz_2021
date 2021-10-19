# frozen_string_literal: true

# Программа викторина

require_relative 'lib/quiz'

current_path = File.dirname(__FILE__)
file_name = "#{current_path}/data/questions.xml"

abort "Файл #{file_name} не найден!" unless File.exist?(file_name)

puts "Мини-викторина. Ответьте на вопросы."

quiz = Quiz.load_from_xml(file_name)

while quiz.in_progress?
  puts quiz.current_question

  print "Ваш ответ: "
  answer = quiz.user_answer(gets.chomp)

  case answer
  when :timeout
    abort "Время истекло, вы програли!"
  when :correct
    puts "Верный ответ! На ответ ушло #{quiz.answer_time.round(1)} сек"
  else
    puts "Неправильно. Правильный ответ: '#{quiz.correct_answer}'"
  end

  quiz.next_question
end

puts "Правильных ответов: #{quiz.right_question} из #{quiz.questions.size}"
puts "Вы набрали #{quiz.score} баллов"
