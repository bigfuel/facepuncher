require "minitest_helper"

describe FacebookEvent do
  it "should have validations" do
    event = Fabricate.build(:facebook_event)

    event.must have_valid(:name)
    event.wont have_valid(:name).when(nil)

    event.must have_valid(:limit)
    event.wont have_valid(:limit).when(nil)
  end

  describe "A Facebook event" do
    before do
      @project = Fabricate(:project)
      @event = Fabricate(:facebook_event, project: @project)
    end

    it "should be valid" do
      @event.must_be :valid?
    end

    it "has cached_results" do
      @project.facebook_events.cached_results.must_be_nil
    end

    it "should raise Koala exception instead of Cacheable exception if bad name" do
      lambda do
        event = Fabricate.build(:facebook_event, name: "bigfuel", project: @project)
        event.save
        Cacheable.update(@project.name, :facebook_event)
      end.must_raise FacebookGraph::Errors::InvalidDataError
    end
  end
end