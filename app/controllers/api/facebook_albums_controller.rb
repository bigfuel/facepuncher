class Api::FacebookAlbumsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    params[:sort_direction] ||= "asc"

    @facebook_albums = @project.facebook_albums
    @facebook_albums = @facebook_albums.order_by(params[:sort_column], params[:sort_direction]) if params[:sort_column]
    @facebook_albums = @facebook_albums.page(params[:page])
    @facebook_albums = @facebook_albums.per(params[:per_page]) if params[:per_page]

    respond_with :api, @project, @facebook_albums
  end

  def show
    @facebook_album = @project.facebook_albums.find(params[:id])

    respond_with :api, @project, @facebook_album
  end
end