class Api::FacebookAlbumsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    @facebook_albums = @project.facebook_albums.page(params[:page])

    respond_with :api, @project, @facebook_albums
  end

  def show
    @response = FacebookGraph::Album.get(@project.id)
    
    respond_with @response
  end

  def create
    @facebook_album = @project.facebook_albums.new(params[:facebook_album])
    @facebook_album.save
    
    respond_with :api, @project, @facebook_album
  end
end