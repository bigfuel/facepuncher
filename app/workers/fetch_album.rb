class FetchAlbum
  include Sidekiq::Worker

  def perform(project_name, album_name)
    FacebookGraph::Album.update project_name, album_name
  end

  def self.queue_all
    Project.active.each do |project|
      project.facebook_albums.each do |album|
        FetchAlbum.perform_async project.name, album.name
      end
    end
  end
end