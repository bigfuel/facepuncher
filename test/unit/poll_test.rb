require "minitest_helper"

describe Poll do
  it "should have validations" do
    poll = Fabricate.build(:poll)
    poll.must have_valid(:question)
    poll.wont have_valid(:question).when(nil)
  end

  describe "A poll" do
    before do
      @project = Fabricate(:project)
      @poll = Fabricate(:poll, project: @project)
    end

    it "should be valid" do
      @poll.must_be :valid?
    end

    it "starts in an inactive state" do
      @poll.must_be :inactive?
    end

    it "validates presence of choice_id when voting" do
      lambda { @poll.vote }.must_raise ArgumentError
      lambda { @poll.vote(nil) }.must_raise RuntimeError
    end

    it "increments vote count when voting" do
      @poll.vote(@poll.choices.first.id)
      @poll.choices.first.votes.must_equal 1
    end

    it "uploads an image to a choice" do
      file = Rails.root.join('test', 'support', 'Desktop.jpg')
      @poll.choices.first.image = File.open(file)
      @poll.save!
      @poll.choices.first.image.wont_be_nil
      @poll.choices.first.image.filename.must_equal 'Desktop.jpg'
      Digest::MD5.hexdigest(File.read(@poll.choices.first.image.current_path)).must_equal Digest::MD5.hexdigest(File.read(file))
    end

    it "has cached_results" do
      results = @project.polls.where(state: "active").order_by([:created_at, :asc]).entries
      @project.polls.cached_results.must_equal results
    end
  end

  describe "Polls" do
    before do
      @inactive = Array.new
      @active = Array.new

      @inactive << Fabricate(:poll)

      2.times do
        p = Fabricate(:poll)
        p.activate
        @active << p
      end
    end

    it "find all inactive polls" do
      (Poll.inactive.entries - @inactive).must_be_empty
    end

    it "find all active polls" do
      (Poll.active.entries - @active).must_be_empty
    end
  end
end