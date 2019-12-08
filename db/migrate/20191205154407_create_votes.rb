class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, foreign_key: true
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, [:votable_type, :votable_id, :user_id], unique: true
  end
end
