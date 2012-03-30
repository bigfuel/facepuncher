include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::TextHelper

module RssFeed
  NUM_RETRIES = 3

  module Errors
    class Error < StandardError; end
    class InvalidDataError < Errors::Error; end
  end

  def self.update(project_name, feed_name)
    project = Project.find_by_name(project_name)
    feed = project.feeds.where(name: feed_name).first

    retriable tries: NUM_RETRIES, interval: 1 do
      rss_feed = []

      Feedzirra::Feed.add_common_feed_entry_element(:enclosure, value: :url, as: :enclosure_url)
      Feedzirra::Feed.add_common_feed_entry_element(:enclosure, value: :type, as: :enclosure_type)
      
      begin
        results = Feedzirra::Feed.fetch_and_parse(feed.url)
        results.entries.each do |entry|
          e = Hash.new
          e[:title]         = entry.title
          e[:url]           = entry.url
          e[:author]        = entry.author
          e[:summary]       = strip_tags(entry.summary)
          e[:content]       = strip_tags(entry.content)
          e[:rawcontent]    = entry.content
          e[:mediaURL]      = entry.enclosure_url
          e[:mediaType]     = entry.enclosure_type
          e[:published]     = entry.published
          e[:categories]    = entry.categories
          rss_feed << e
        end
      rescue
        raise Errors::InvalidDataError, "Please check values for #{feed.name} in #{project.name}"
      end
      
      feed.update_attributes(rss: rss_feed)
    end
  end
end