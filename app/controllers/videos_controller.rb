class VideosController < ApplicationController
  def create
    @video = @project.videos.new(params[:video])
    respond_to do |format|
      if @video.save
        format.json { render json: @video }
      else
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end
end