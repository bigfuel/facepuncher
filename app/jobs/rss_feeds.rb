class RssFeeds
  @queue = :rss_feeds

  class << self
    def perform
      Project.active.each do |project|
        Cacheable.update(project.name, :feeds)
      end
    end
  end
end