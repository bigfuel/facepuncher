require "test_helper"

class FacebookEventTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:limit)

  context FacebookEvent do
    setup do
      @project = Fabricate(:project)
      @event = Fabricate(:facebook_event, project: @project)
    end

    should "be valid" do
      assert @event.valid?
    end

    should "have #cached_results method" do
      assert_respond_to @project.facebook_events, :cached_results
    end

    should "return results when #cached_results" do
      assert_equal false, @project.facebook_events.cached_results.empty?
    end

    should "raise Koala exception instead of Cacheable exception if bad name" do
      assert_raise FacebookGraph::Errors::InvalidDataError do
        event = Fabricate.build(:facebook_event, name: "bigfuel", project: @project)
        event.save
        Cacheable.update(@project.name, :facebook_event)
      end
    end
  end
end