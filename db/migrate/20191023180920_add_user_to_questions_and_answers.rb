class AddUserToQuestionsAndAnswers < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :user, null: false, foreign_key: true
    add_reference :answers, :user, null: false, foreign_key: true
  end
end
