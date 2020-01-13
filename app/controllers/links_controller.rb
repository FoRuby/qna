class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])

    authorize! :destroy, @link

    @link.destroy
    flash.now[:success] = 'Link successfully deleted.'
  end
end
