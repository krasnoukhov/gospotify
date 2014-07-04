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
      @user = UserRepository.all.first
    end

    describe "index" do
      before do
        visit "/provider/soundcloud/playlists"
        @response = Oj.load(page.body)
      end

      scenario do
        @response.size.must_equal 2
        @response.map { |x| x["user_id"] }.uniq.must_equal [@user.id]
        @response.map { |x| x["provider"] }.uniq.must_equal ["soundcloud"]
        @response.first["external_id"].must_equal "favorites"
        @response.last["title"].must_equal "Mixtapes"
      end
    end

    describe "update" do
      before do
        page.driver.submit :patch, "/provider/soundcloud/playlists/12345", {}
        @response = Oj.load(page.body)
      end

      scenario do
        @response["user_id"].must_equal @user.id
        @response["job_id"].length.must_equal 24
        @response["status"].must_equal "queued"
      end
    end

    describe "show" do
      before do
        visit "/provider/soundcloud/playlists/12345"
        @response = Oj.load(page.body)
      end

      scenario do
        @response["user_id"].must_equal @user.id
      end
    end
  end
end