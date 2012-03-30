class RssFeeds
  include Sidekiq::Worker

  def perform(project_name, feed_name)
    RssFeed.update project_name, feed_name
  end

  def self.queue_all
    Project.active.each do |project|
      project.feeds.each do |feed|
        RssFeeds.perform_async project.name, feed.name
      end
    end
  end
end