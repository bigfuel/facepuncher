class ImagesController < ApplicationController
  def create
    @image = @project.images.new(params[:image])
    respond_to do |format|
      if @image.save
        format.html { redirect_to "#{params[:redirect_to]}?image_id=#{@image.id}&signed_request=#{params[:signed_request]}" }
        format.json { render json: @image }
      else
        logger.error @image.errors.messages
        format.html { redirect_to "#{params[:redirect_to]}?error=true&signed_request=#{params[:signed_request]}" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end
end