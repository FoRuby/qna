require 'rspec/expectations'

RSpec::Matchers.define :be_an_author_of do |item|
  match do |user|
    user.author?(item)
  end

  description do
    "be author of #{item.class.to_s.downcase}"
  end
end
