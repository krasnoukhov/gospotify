require "test_helper"

class SoundcloudClient
  def remote_playlists
    [{ id: 12345, title: "Mixtapes" }]
  end
end

feature "Playlists" do
  before do
    before_each

    visit "/auth/spotify"
    visit "/auth/soundcloud"
  end

  after do
    visit "/auth/signout"
  end

  describe "soundcloud" do
    before do
      visit "/provider/soundcloud/playlists"

      @user = UserRepository.all.first
      @response = Oj.load(page.body)
    end

    scenario "has playlists" do
      @response.size.must_equal 2
      @response.map(&:class).uniq.must_equal [Playlist]
      @response.map(&:user_id).uniq.must_equal [@user.id]
      @response.map(&:provider).uniq.must_equal ["soundcloud"]
      @response.first.external_id.must_equal "favorites"
      @response.last.title.must_equal "Mixtapes"
    end

    describe "can sync" do
      before do
        page.driver.submit :patch, "/provider/soundcloud/playlists/12345", {}
      end

      scenario "syncs" do
        page.body.must_equal '{"status":"ok"}'
      end
    end
  end
end
