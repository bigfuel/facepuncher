class FacebookAlbums
  @queue = :facebook_albums

  class << self
    def perform
      Project.active.each do |project|
        Cacheable.update(project.name, :facebook_albums)
      end
    end
  end
end