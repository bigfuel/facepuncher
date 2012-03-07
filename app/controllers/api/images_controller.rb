class Api::ImagesController < ApplicationController
  respond_to :json, :xml

  def index
    @images = @project.images.page(params[:page])

    respond_with :api, @project, @images
  end

  def show
    @image = @project.images.find(params[:id])

    respond_with :api, @project, @image
  end

  def create
    @image = @project.images.new(params[:image])
    @image.save
    respond_with :api, @project, @image
  end
end