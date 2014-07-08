require "test_helper"

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
      describe "remote" do
        before do
          visit "/provider/soundcloud/playlists"
          @response = Oj.load(page.body)
        end

        scenario do
          @response.size.must_equal 3
          @response.map { |x| x["id"] }.uniq.must_equal [nil]
          @response.map { |x| x["user_id"] }.uniq.must_equal [@user.id]
          @response.map { |x| x["provider"] }.uniq.must_equal ["soundcloud"]
          @response.first["external_id"].must_equal "profile"
          @response.last["title"].must_equal "Mixtapes"
        end
      end

      describe "local" do
        before do
          page.driver.submit :patch, "/provider/soundcloud/playlists/12345", {}
          visit "/provider/soundcloud/playlists"
          @response = Oj.load(page.body)
        end

        scenario do
          @response.size.must_equal 3
          @response.first["id"].must_be_nil
          @response.last["id"].wont_be_nil
        end
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
        @response["status"]["status"].must_match /queued|working/
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
