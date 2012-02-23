require "test_helper"

class PollTest < ActiveSupport::TestCase
  should validate_presence_of(:question)

  context Poll do
    setup do
      @poll = Fabricate(:poll)
    end

    should "be valid" do
      assert @poll.valid?
    end

    should "start in an inactive state" do
      assert @poll.inactive?
    end

    should "validate presence of choice_id when voting" do
      assert_raises(ArgumentError) { @poll.vote }
      assert_raise(RuntimeError) do
        @poll.vote(nil)
      end
    end

    should "increment vote count when voting" do
      assert @poll.vote(@poll.choices.first.id)
      assert_equal 1, @poll.choices.first.votes
    end

    should "upload an image to a choice" do
      file = Rails.root.join('test', 'support', 'Desktop.jpg')
      @poll.choices.first.image = File.open(file)
      @poll.save!
      assert_not_nil @poll.choices.first.image
      assert_equal 'Desktop.jpg', @poll.choices.first.image.filename
      assert_equal Digest::MD5.hexdigest(File.read(file)), Digest::MD5.hexdigest(File.read(@poll.choices.first.image.current_path))
    end

    should "return cached_results" do
      results = @project.submissions.where(state: "active").order_by([:created_at, :asc]).entries
      assert_equal results, @project.submissions.cached_results
    end
  end

  context "Polls" do
    setup do
      @inactive = Array.new
      @active = Array.new

      @inactive << Fabricate(:poll)

      2.times do
        p = Fabricate(:poll)
        p.activate
        @active << p
      end
    end

    should "find all inactive polls" do
      polls = Poll.inactive
      assert_equal 1, polls.count
      assert_empty @inactive - polls
    end

    should "find all active polls" do
      polls = Poll.active
      assert_equal 2, polls.count
      assert_empty @active - polls
    end
  end
end