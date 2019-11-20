require 'rails_helper'

RSpec.describe AttachmentsHelper, type: :helper do
  describe '#record_css_id_of_attachment' do
    let(:answer) { create(:answer) }

    context 'when the attachment exist' do
      let(:attachment) do
        answer.files.attach(
          io: File.open("#{Rails.root}/spec/fixtures/files/image1.jpg"),
          filename: 'image1.jpg'
        ).first
      end

      subject { helper.record_css_id_of_attachment(attachment) }

      it { is_expected.to eq("#answer-#{answer.id}") }
    end

    context "when the attachment doesn't exist" do
      subject { helper.record_css_id_of_attachment(nil) }

      it { is_expected.to be_nil }
    end
  end
end
