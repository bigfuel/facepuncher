class Api::PostsController < ApplicationController
  before_filter :load_project
  append_before_filter :check_for_project

  respond_to :json, :xml

  def index
    @posts = @project.posts.page(params[:page])
    @posts = @posts.has_images if params[:has_images]
    @posts = @posts.tags_tagged_with(params[:tags]) if params[:tags]

    respond_with :api, @project, @posts
  end

  def show
    @post = @project.posts.find(params[:id])

    respond_with :api, @project, @post
  end
end
