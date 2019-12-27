class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment

  authorize_resource

  def destroy
    if current_user.author?(@attachment.record)
      @attachment.purge
      flash.now[:success] = 'Attachment successfully deleted.'
    end
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
