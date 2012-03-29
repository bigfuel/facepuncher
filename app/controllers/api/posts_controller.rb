class Api::PostsController < ApplicationController
  before_filter :load_project
  append_before_filter :check_for_project

  respond_to :json, :xml

  def index
    params[:sort_direction] ||= "asc"
    
    @posts = @project.posts
    @posts = @posts.where(state: params[:state]) if params[:state]
    @posts = @posts.order_by(params[:sort_column], params[:sort_direction]) if params[:sort_column]
    @posts = @posts.has_images if params[:has_images]
    @posts = @posts.tags_tagged_with(params[:tags]) if params[:tags]
    @posts = @posts.page(params[:page])
    @posts = @posts.per(params[:per_page]) if params[:per_page]

    respond_with :api, @project, @posts
  end

  def show
    @post = @project.posts.find(params[:id])

    respond_with :api, @project, @post
  end
end
