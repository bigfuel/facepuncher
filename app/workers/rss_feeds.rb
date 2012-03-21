class RssFeeds
  include Sidekiq::Worker

  def perform
    Project.active.each do |project|
      RssFeed.update(project.name)
    end
  end
end