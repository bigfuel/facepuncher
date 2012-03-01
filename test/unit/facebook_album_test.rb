require "minitest_helper"

describe FacebookAlbum do
  it "should have validations" do
    album = Fabricate.build(:facebook_album)

    album.must have_valid(:name)
    album.wont have_valid(:name).when(nil)

    album.must have_valid(:set_id)
    album.wont have_valid(:set_id).when(nil)
  end

  describe "A Facebook album" do
    before do
      @project = Fabricate(:project)
      @album = Fabricate(:facebook_album, project: @project)
    end

    it "should be valid" do
      @album.must_be :valid?
    end

    it "has cached results" do
      @project.facebook_albums.cached_results.wont_be_nil
    end

    it "raise Koala exception instead of Cacheable exception if bad set_id" do
      lambda do
        album = Fabricate.build(:facebook_album, set_id: 123123, project: @project)
        album.save
        Cacheable.update(@project.name, :facebook_album)
      end.must_raise FacebookGraph::Errors::InvalidDataError
    end
  end
end