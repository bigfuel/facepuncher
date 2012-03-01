require "minitest_helper"

describe Image do
  it "should have validations" do
    image = Fabricate.build(:image)
    image.must have_valid(:image)
    image.wont have_valid(:image).when(nil)
  end

  describe "An image" do
    before do
      @project = Fabricate(:project)
      @image = Fabricate(:image, project: @project)
    end

    it "should be valid" do
      @image.must_be :valid?
    end

    it "starts in a pending state" do
      @image.must_be :pending?
    end

    it "has cached_results" do
      results = @project.images.order_by([:created_at, :asc]).entries
      @project.images.cached_results.must_equal results
    end

    it "returns as_json" do
      skip
    end
  end

  describe "An unpersisted image" do
    before do
      @image = Fabricate.build(:image)
    end

    it "returns the image attribute when serialized to json" do
      @image.as_json['image'].wont_be_nil
    end
  end

  describe "Images" do
    before do
      @pending = Array.new
      @denied = Array.new
      @approved = Array.new

      @pending << Fabricate(:image)

      2.times do
        i = Fabricate(:image)
        i.deny
        @denied << i
      end

      3.times do
        i = Fabricate(:image)
        i.approve
        @approved << i
      end
    end

    it "finds all pending" do
      (Image.pending.entries - @pending).must_be_empty
    end

    it "finds all denied" do
      (Image.denied.entries - @denied).must_be_empty
    end

    it "finds all approved" do
      (Image.approved.entries - @approved).must_be_empty
    end
  end
end