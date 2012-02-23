require "test_helper"

class ImageTest < ActiveSupport::TestCase
  should validate_presence_of(:image)

  context Image do
    setup do
      @project = Fabricate(:project)
      @image = Fabricate(:image)
    end

    should "be valid" do
      assert @image.valid?
    end

    should "start in a pending state" do
      assert @image.pending?
    end

    should "return cached_results" do
      results = @project.images.order_by([:created_at, :asc]).entries
      assert_equal results, @project.images.cached_results
    end

    should "return as_json" do
      flunk
    end
  end

  context "Unpersisted image" do
    setup do
      @image = Fabricate.build(:image)
    end

    should "return the image attribute when serialized to json" do
      refute_nil @image.as_json['image']
    end
  end

  context "Images" do
    setup do
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

    should "find all pending images" do
      images = Image.pending
      assert_equal 1, images.count
      assert_empty @pending - images
    end

    should "find all denied image" do
      images = Image.denied
      assert_equal 2, images.count
      assert_empty @denied - images
    end

    should "find all approved images" do
      images = Image.approved
      assert_equal 3, images.count
      assert_empty @approved - images
    end
  end
end