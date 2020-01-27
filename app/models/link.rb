class Link < ApplicationRecord
  default_scope -> { order(created_at: :asc) }

  URL_REGEXP = %r{https?:\/\/[\S]+}.freeze
  GIST_URL_REGEXP = %r{https?:\/\/gist.github.com\/[\S]+}.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: {
    with: URL_REGEXP,
    message: 'invalid format'
  }

  after_create :save_gist_body!, if: :gist?

  def gist?
    url.match? GIST_URL_REGEXP
  end

  private

  def save_gist_body!
    gist_body = GistService.new(url).call
    update! gist_body: gist_body
  end
end
