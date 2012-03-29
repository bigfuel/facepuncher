module FacebookGraph

  def self.get_token(facebook_app_id, facebook_app_secret)
    oauth = Koala::Facebook::OAuth.new(facebook_app_id, facebook_app_secret)
    token = oauth.get_app_access_token
    Koala::Facebook::API.new(token)
  end

  module Errors
    class Error < StandardError; end
    class InvalidDataError < Errors::Error; end
  end

  module Album
    def self.update(project_name, album_name)
      project = Project.find_by_name(project_name)
      album = project.facebook_albums.where(name: album_name).first

      facebook_graph = FacebookGraph.get_token(project.facebook_app_id, project.facebook_app_secret)

      begin
        photos = facebook_graph.get_connections(album.set_id, "photos")
      rescue Koala::Facebook::APIError
        raise Errors::InvalidDataError, "Please check values in #{project.name}"
      end

      album.update_attributes(graph: photos)
    end
  end

  module Event
    def self.update(project_name, event_name)
      project = Project.find_by_name(project_name)
      event = project.facebook_events.where(name: event_name).first

      facebook_graph = FacebookGraph.get_token(project.facebook_app_id, project.facebook_app_secret)

      begin
        event_list = facebook_graph.get_connections(event.name, "events")
      rescue Koala::Facebook::APIError
        raise Errors::InvalidDataError, "Please check values in #{project.name}"
      end

      # event_list.each { |e| e['start_time'] = Date.parse(e['start_time']) }

      event.update_attributes(graph: event_list)
    end
  end
end