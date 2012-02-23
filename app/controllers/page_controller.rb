class PageController < ApplicationController
  before_filter :load_project
  around_filter :load_digests
  prepend_view_path ViewTemplate.resolver

  def index
  end

  protected
  def load_digests
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

  def load_project
    @project = params[:project_name] && Project.active.where(name: params[:project_name]).first
    not_found unless @project
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