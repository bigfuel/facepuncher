require "test_helper"

class EventTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:start_date)

  context Event do
    setup do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location)
    end

    should "be valid" do
      assert @event.valid?
    end

    should "approve an event" do
      @event.approve
      assert @event.approved?
    end

    should "deny an event" do
      @event.deny
      assert @event.denied?
    end

    should "start in a pending state" do
      assert @event.pending?
    end
  end

  context "Unperisted event" do
    setup do
      @event = Fabricate.build(:event, start_date: "2013-05-11", end_date: "2013-05-13")
    end

    should "format the start and end date in its json representation" do
      assert_equal 'Sat May 11, 2013 12:00 AM', @event.as_json['start_date']
      assert_equal 'Mon May 13, 2013 12:00 AM', @event.as_json['end_date']
    end
  end

  context "Events" do
    setup do
      @pending = Array.new
      @denied = Array.new
      @approved = Array.new
      @past = Array.new
      @future = Array.new

      e = Fabricate(:event)
      @pending << e
      @future << e

      2.times do
        e = Fabricate(:event)
        e.deny
        @denied << e
        @future << e
      end

      3.times do
        e = Fabricate(:event)
        e.approve
        @approved << e
        @future << e
      end

      2.times do
        e = Fabricate(:event, start_date: 1.day.ago )
        @past << e
        @pending << e
      end
    end

    should "find all pending events" do
      events = Event.pending
      assert_equal 3, events.count
      assert_empty @pending - events
    end

    should "find all denied events" do
      events = Event.denied
      assert_equal 2, events.count
      assert_empty @denied - events
    end

    should "find all approved events" do
      events = Event.approved
      assert_equal 3, events.count
      assert_empty @approved - events
    end

    should "find all future events" do
      events = Event.future
      assert_equal 6, events.count
      assert_empty @future - events
    end
  end
end