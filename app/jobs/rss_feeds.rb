class RssFeeds
  @queue = :rss_feeds

  class << self
    def perform
      Project.active.each do |project|
        RssFeed.update(project.name)
      end
    end
  end
end