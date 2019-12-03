require 'uri'

class GistService
  attr_reader :url

  def initialize(gist_url)
    @url = URI.parse(gist_url)
  end

  def call
    begin
      gist_content
    rescue Octokit::NotFound
      nil
    end
  end

  private

  def gist_content
    content = ''
    Octokit.gist(gist_id).files.to_attrs.values.each do |file|
      content += file[:content]
    end

    content
  end

  def gist_id
    url.path.split('/').last
  end
end
