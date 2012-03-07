class Api::PostsController < ApplicationController
  respond_to :json, :xml

  def index
    @posts = @project.posts.approved.page(params[:page])
    @posts = @posts.has_images if params[:has_images]
    @posts = @posts.tags_tagged_with(params[:tags]) if params[:tags]

    respond_with :api, @project, @post
  end

  def show
    @post = @project.posts.approved.find(params[:id])

    respond_with :api, @project, @post
  end
end
