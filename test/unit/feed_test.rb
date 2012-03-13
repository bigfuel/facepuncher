require "minitest_helper"

describe Feed do
  describe "A feed" do
    before do
      @project = Fabricate(:project)
      @rss = Fabricate(:feed, project: @project)
    end

    it "should have validations" do
      new_rss = Fabricate.build(:feed)
      new_rss.must have_valid(:name)
      new_rss.wont have_valid(:name).when(nil)

      new_rss.must have_valid(:url)
      new_rss.wont have_valid(:url).when(nil)

      new_rss.must have_valid(:limit)
      new_rss.wont have_valid(:limit).when(nil)

      new_rss.must have_valid(:name).when(@rss.name)

      newer_rss = Fabricate.build(:feed, project: @project)
      newer_rss.must have_valid(:name).when(new_rss.name)
      newer_rss.wont have_valid(:name).when(@rss.name)
    end

    it "should be valid" do
      @rss.must_be :valid?
    end

    it "returns feed results in a hash if updated" do
      skip
    end

    it "returns nil when fetching single feed if it doesn't exist" do
      RssFeed.read(@project.name, "123123123").must_be_nil
    end

    it "returns results when fetching single feed" do
      RssFeed.get(@project.name, @rss.name).wont_be_empty
    end
  end
end