class DailyDigestService
  def self.send_digest
    User.find_each { |user| DailyDigestMailer.digest(user).deliver_later }
  end
end
