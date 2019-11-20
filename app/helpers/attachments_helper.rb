module AttachmentsHelper
  def record_css_id_of_attachment(attachment)
    if attachment.present?
      "##{attachment.record_type.downcase}-#{attachment.record_id}"
    end
  end
end
