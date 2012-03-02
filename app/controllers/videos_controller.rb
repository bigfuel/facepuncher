class VideosController < ApplicationController
  respond_to :json, :html

  def create
    @video = @project.videos.new(params[:video])
    @video.save

    respond_with @project, @video
  end
end