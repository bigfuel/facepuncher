require "test_helper"

class FeedTest < ActiveSupport::TestCase
  setup do
    @project = Fabricate(:project)
    @rss = Fabricate(:feed, project: @project)
  end

  context Feed do
    should validate_presence_of(:name)
    should validate_uniqueness_of(:name).scoped_to(:project_id).with_message("has already been used in this project.")
    should validate_presence_of(:url)
    should validate_numericality_of(:limit)

    should "be valid" do
      assert @rss.valid?
    end

    should "have #cached_results method" do
      assert_respond_to @project.feeds, :cached_results
    end

    should "return true if #cached_results" do
      assert_equal true, @project.feeds.cached_results
    end
  end

  context RssFeed do
    should "return feed results in a hash if updated" do
      flunk
    end

    should "return nil when fetching single feed if it doesn't exist" do
      assert_equal nil, RssFeed.read(@project.name, "123123123")
    end

    should "return results when fetching single feed" do
      assert_equal false, RssFeed.get(@project.name, @rss.name).empty?
    end
  end
end