# Admin
admin = User.new(
  email: 'admin@example.com',
  password: 'foobar',
  admin: true
)
admin.skip_confirmation!
admin.save

# Users
users = []
10.times do
  u = User.new(email: Faker::Internet.email, password: 'foobar', admin: false)
  u.skip_confirmation!
  users << u
  u.save
end

# Questions
questions = []
10.times do
  questions << users.sample.questions.create(
    title: Faker::Lorem.question,
    body: Faker::Lorem.paragraph(sentence_count: 10)
  )
end

# Answers
answers = []
questions.each do |question|
  rand(1..10).times do
    answers << users.sample.answers.create(
      body: Faker::Books::Lovecraft.sentence(word_count: 10),
      question_id: question.id,
      best: false
    )
  end
end

# Comments
comments = []
questions.each do |question|
  rand(1..5).times do
    comments << users.sample.comments.create(
      body: Faker::Books::Lovecraft.fhtagn,
      commentable: question
    )
  end
end
answers.each do |answer|
  rand(1..5).times do
    comments << users.sample.comments.create(
      body: Faker::Books::Lovecraft.fhtagn,
      commentable: answer
    )
  end
end
