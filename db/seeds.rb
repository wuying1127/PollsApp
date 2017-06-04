# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.transaction do
  user3 = User.create!(user_name: 'John Stark')
  user4 = User.create!(user_name: 'Tom Yates')

  p2 = Poll.create!(title: 'The Best Point Guard', author_id: user3.id)

  q2 = Question.create!(text: "Who is the Best Point Guard?", poll_id: p2.id)
  ac5 = AnswerChoice.create!(text: "Steve Nash", question_id: q2.id)
  ac6 = AnswerChoice.create!(text: "John Stockton", question_id: q2.id)
  ac7 = AnswerChoice.create!(text: "Jason Kidd", question_id: q2.id)

  r2 = Response.create!(respondent_id: user4.id, answer_choice_id: ac6.id)
  r3 = Response.create!(respondent_id: user3.id, answer_choice_id: ac7.id)

end
