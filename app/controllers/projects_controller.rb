class ProjectsController < PageController
  respond_to :html, :json

  prepend_view_path APP_CONFIG['project_path'] if Rails.env.development?

  def show
    @image = @project.images.new
    @post = @project.posts.new
    @poll = @project.polls.new
    @event = @project.events.new
    @event.build_location
    @video = @project.videos.new
    @signup = @project.signups.new

    Project.reflect_on_all_associations(:references_many).map(&:class_name).each do |model_class|
      model = model_class.underscore.to_sym
      key = model.to_s.tableize
      if @project.send(key).respond_to?(:cached_results)
        results = Cacheable.get(@project.name, model)
        instance_variable_set("@#{key}", results)
      end
    end

    @signed_request = decode_signed_request(params[:signed_request], @project.facebook_app_id, @project.facebook_app_secret) if @project.facebook_app_id && @project.facebook_app_secret
    @liked = @signed_request['page']['liked'] rescue false
    @liked = true if Rails.env.development?

    if Rails.env.development? || stale?(etag: [@project, params[:signed_request]], last_modified: @project.updated_at.utc, public: true)
      render "#{@project.name}/index"
    end
  end

  def deauthorize
    render nothing: true
  end
end