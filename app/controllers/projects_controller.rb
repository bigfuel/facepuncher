class ProjectsController < ApplicationController
  before_filter :load_project, :check_for_project
  around_filter :load_digests
  prepend_view_path APP_CONFIG['project_path'] if Rails.env.development?
  append_view_path ViewTemplate.resolver

  respond_to :html, :json, :xml

  def show
    @image = @project.images.new
    @post = @project.posts.new
    @poll = @project.polls.new
    @event = @project.events.new
    @event.build_location
    @video = @project.videos.new
    @signup = @project.signups.new

    @signed_request = decode_signed_request(params[:signed_request], @project.facebook_app_id, @project.facebook_app_secret)
    @liked = @signed_request['page']['liked'] rescue false
    @liked = true if Rails.env.development?

    if Rails.env.development? || stale?(etag: [@project, params[:signed_request]], last_modified: @project.updated_at.utc, public: true)
      render "#{@project.name}/index"
    end
  end

  def deauthorize
    render nothing: true
  end

  protected
  def load_project
    @project = Project.active.find_by_name(params[:id])
  end

  def load_digests
    return unless @project
    begin
      digests = Rails.cache.read("digests:#{@project.name}")
      # Todo, also check s3 for manifest.yml
      if digests
        default_digests = Rails.application.config.assets.digests
        Rails.application.config.assets.digests = digests
      end
      yield
    ensure
      Rails.application.config.assets.digests = default_digests if digests
    end
  end

  def decode_signed_request(signed_request, app_id, app_secret)
    if signed_request
      oauth = Koala::Facebook::OAuth.new(app_id, app_secret)
      return oauth.parse_signed_request(signed_request)
    end
  end

  def get_access_token
    oauth = Koala::Facebook::OAuth.new(@project.facebook_app_id, @project.facebook_app_secret)
    oauth.get_app_access_token
  end

end