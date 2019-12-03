class Question < ApplicationRecord
  include HasLinks

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true
end
