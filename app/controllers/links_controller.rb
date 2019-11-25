class LinksController < ApplicationController

  before_action :authenticate_user!
  before_action :set_link

  def destroy
    if current_user.author?(@link.linkable)
      @link.destroy
      flash.now[:success] = 'Link successfully deleted.'
    end
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end
end
