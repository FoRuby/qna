class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  URL_REGEXP = /https?:\/\/[\S]+/

  validates :name, :url, presence: true
  validates :url, format: {
    with: URL_REGEXP,
    message: 'Invalid URL format'
  }
end
