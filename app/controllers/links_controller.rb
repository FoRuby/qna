class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @link = Link.find(params[:id])

    if current_user.author_of?(@link.linkable)
      @link.destroy
      flash.now[:success] = 'Link successfully deleted.'
    end
  end
end
