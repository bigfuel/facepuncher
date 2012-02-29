include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::TextHelper

module RssFeed
  NUM_RETRIES = 3

  class << self
    def update(project_name)
      project = Project.find_by_name(project_name)

      project.feeds.each do |feed_data|
        retriable tries: NUM_RETRIES, interval: 1 do
          rss_feed = []
          Feedzirra::Feed.add_common_feed_entry_element(:enclosure, value: :url, as: :enclosure_url)
          Feedzirra::Feed.add_common_feed_entry_element(:enclosure, value: :type, as: :enclosure_type)
          Feedzirra::Feed.fetch_and_parse(feed_data.url,
            on_success: lambda do |response_url, feed|
              feed.entries.each do |entry|
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
              Rails.cache.write("projects:#{project.name}:feeds:#{feed_data.name}", rss_feed)
            end,
            on_failure: lambda {|url, response_code, response_header, response_body| raise response_body }
          )
        end
      end
    end

    def read(project_name, feed_name)
      Rails.cache.read("projects:#{project_name}:feeds:#{feed_name}")
    end

    def get(project_name, feed_name)
      results = read(project_name, feed_name)
      unless results
        update(project_name)
        results = read(project_name, feed_name)
      end
      results
    end
  end
end