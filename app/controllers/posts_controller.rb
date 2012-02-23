class PostsController < ApplicationController
    def index
    @posts = @project.posts.approved.page(params[:page])
    @posts = @posts.has_images if params[:has_images]
    @posts = @posts.tags_tagged_with(params[:tags]) if params[:tags]

    respond_to do |format|
      format.json { render json: @posts.as_json(methods: :image_url) }
    end
  end

  def show
    @post = @project.posts.approved.find(params[:id])

    respond_to do |format|
      format.json { render json: @post.as_json(methods: :image_url) }
    end
  end
end
