require "test_helper"

class FacebookAlbumTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:set_id)

  context FacebookAlbum do
    setup do
      @project = Fabricate(:project)
      @album = Fabricate(:facebook_album, project: @project)
    end

    should "be valid" do
      assert @album.valid?
    end

    should "have #cached_results method" do
      assert_respond_to @project.facebook_albums, :cached_results
    end

    should "return results when #cached_results" do
      assert_equal false, @project.facebook_albums.cached_results.empty?
    end

    should "raise Koala exception instead of Cacheable exception if bad set_id" do
      assert_raise FacebookGraph::Errors::InvalidDataError do
        album = Fabricate.build(:facebook_album, set_id: 123123, project: @project)
        album.save
        Cacheable.update(@project.name, :facebook_album)
      end
    end
  end
end