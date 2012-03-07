class Api::VideosController < ApplicationController
  respond_to :json, :xml

  def index
    @videos = @project.videos.approved.page(params[:page])

    respond_with :api, @project, @videos
  end

  def show
    @video = @project.videos.approved.find(params[:id])

    respond_with :api, @project, @video
  end

  def create
    @video = @project.videos.new(params[:video])
    @video.save

    respond_with :api, @project, @video
  end
end