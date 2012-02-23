include ActionView::Helpers::SanitizeHelper
include ActionView::Helpers::TextHelper

module RssFeed
  NUM_RETRIES = 3

  class << self
    def update(project_id)
      project = Project.find(project_id)

      project.feeds.each do |feed_data|
        retriable tries: NUM_RETRIES, interval: 1 do
          entries = []
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
                entries << e
              end
              Rails.cache.write("projects:#{project.name}:feeds:#{feed_data.name}", entries)
            end,
            on_failure: lambda {|url, response_code, response_header, response_body| raise response_body }
          )
          entries
        end
      end
    end

    def read(project_name, feed_name)
      Rails.cache.read("projects:#{project_name}:feeds:#{feed_name}")
    end

    def get(project_id, feed_name)
      project = Project.find(project_id)

      results = read(project.name, feed_name)
      unless results
        update(project_id)
        results = read(project.name, feed_name)
      end
      results
    end
  end
end