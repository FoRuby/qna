question_authors = FactoryBot.create_list(:user, 3)
answer_authors = FactoryBot.create_list(:user, 3)

questions = []
question_authors.each do |user|
  questions << FactoryBot.create(:question, user: user)
end

questions = question_authors.map do |user|
  FactoryBot.create(:question, user: user)
end

answers = []
questions.each do |question|
  answer_authors.each do |user|
    answers << FactoryBot.create(:answer, question: question, user: user,)
  end
end
