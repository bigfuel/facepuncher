class ImagesController < ApplicationController
  respond_to :json

  def create
    @image = @project.images.new(params[:image])
    @image.save
    respond_with @project, @image
  end
end