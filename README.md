# Rails QnA
Small Rails applicatio that implements StackOverflow functionality

# Application Gems
* Sass for Sass/Scss stylesheets

* Bootstrap

* Material Icons for Rails

* Slim Template Engine

* Thinking Sphinx full-text search

* Devise for user authentication

* CanCanCan for resource authorization

* FactoryBot for creating test data

* Faker for generating test data content

* RSpec for unit testing

* Capybara for integration testing

* Capistrano deployment automation tool

## Histories:

User can sign up(with OmniAuth GitHub VK Yandex)\
User can sign in\
Authorized can sign out\

Authorized User can create Question with (Attachments, Links)\
Authorized Author can edit Question with (Attachments, Links)\
Authorized Author can delete Question\
User can see a list of all Questions\
User can see a current Question with Answers, Comments, Attachments, Links\
User can subscribe on Question\
User can unsubscribe from Question\

Authorized User can create Answer with (Attachments, Links) \
  AND and it will appear for all users who are on the same Questin page\
Authorized Author can edit Answer with (Attachments, Links)\
Authorized Author can delete Answer\


Authorized Question Author can create Reward for best Answer\
Authorized User can see a list of his Rewards\
Authorized Question Author can mark Answer as best\

Authorized User can create Comment for (Question, Answer)\

Authorized User can Vote(UP DOWN) for (Question, Answer)\
Authorized User can cancel his Vote\

User can search on Users, Question, Comments, Answers
