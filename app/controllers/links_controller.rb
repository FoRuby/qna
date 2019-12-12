class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    if current_user.author?(@link.linkable)
      @link.destroy
      flash.now[:success] = 'Link successfully deleted.'
    end
  end
end