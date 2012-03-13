require "minitest_helper"

describe Event do
  it "should have validations" do
    location = Fabricate.build(:location)
    event = Fabricate.build(:event, location: location)
    event.must have_valid(:name)
    event.wont have_valid(:name).when(nil)

    event.must have_valid(:start_date)
    event.wont have_valid(:start_date).when(nil)
  end

  describe "An event" do
    before do
      location = Fabricate.build(:location)
      @event = Fabricate(:event, location: location)
    end

    it "should be valid" do
      @event.must_be :valid?
    end

    it "should be approved" do
      @event.approve
      @event.must_be :approved?
    end

    it "should be denied" do
      @event.deny
      @event.must_be :denied?
    end

    it "starts in a pending state" do
      @event.must_be :pending?
    end
  end

  describe "An unperisted event" do
    before do
      @event = Fabricate.build(:event, start_date: "2013-05-11", end_date: "2013-05-13")
    end

    it "formats the start and end date in its json representation" do
      @event.as_json['start_date'].must_equal 'Sat May 11, 2013 12:00 AM'
      @event.as_json['end_date'].must_equal 'Mon May 13, 2013 12:00 AM'
    end
  end

  describe "Events" do
    before do
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

    it "finds all pending" do
      (Event.pending.entries - @pending).must_be_empty
    end

    it "finds all denied" do
      (Event.denied.entries - @denied).must_be_empty
    end

    it "finds all approved" do
      (Event.approved.entries - @approved).must_be_empty
    end

    it "finds all future" do
      (Event.future.entries - @future).must_be_empty
    end
  end
end