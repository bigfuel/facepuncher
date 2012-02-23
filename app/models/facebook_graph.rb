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
    def self.get(project_id)
      project = FacebookGraph.load_project(project_id)
      graph = FacebookGraph.get_token(project.facebook_app_id, project.facebook_app_secret)

      albums = Hash.new
      project.facebook_albums.each do |album|
        begin
          photos = graph.get_connections(album.set_id, "photos")
        rescue Koala::Facebook::APIError
          raise Errors::InvalidDataError, "Please double check facebook album values for #{project.name}."
        end
        albums[album.name] = photos
      end
      albums
    end
  end

  module Event
    def self.get(project_id)
      project = FacebookGraph.load_project(project_id)
      graph = FacebookGraph.get_token(project.facebook_app_id, project.facebook_app_secret)

      events = Hash.new
      project.facebook_events.each do |event|
        begin
          event_list = graph.get_connections(event.name, "events")
        rescue Koala::Facebook::APIError
          raise Errors::InvalidDataError, "Please double check facebook event values for #{project.name}."
        end
        event_list.each do |e|
          e['start_time'] = Date.parse(e['start_time'])
        end
        event_list = event_list.reverse.take(event.limit)
        events[event.name] = event_list
      end
      events
    end
  end

  private
  def self.load_project(project_id)
    Project.find(project_id)
  end
end