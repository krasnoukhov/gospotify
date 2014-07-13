require "test_helper"

feature "Playlists" do
  before do
    before_each
    visit "/auth/spotify"
  end

  after do
    visit "/auth/signout"
  end

  GoSpotify::Application::PROVIDERS.each do |provider|
    describe provider do
      before do
        visit "/auth/#{provider}"
        @user = UserRepository.all.first
        @auth = AuthRepository.all.find { |x| x.provider == provider.to_s }
      end

      describe "index" do
        describe "remote" do
          before do
            visit "/provider/#{provider}/playlists"
            @response = Oj.load(page.body)
          end

          scenario do
            @response.size.must_equal @auth.client.playlists.size
            @response.map { |x| x["id"] }.uniq.must_equal [nil]
            @response.map { |x| x["user_id"] }.uniq.must_equal [@user.id]
            @response.map { |x| x["provider"] }.uniq.must_equal [provider.to_s]
            @response.first["external_id"].must_equal @auth.client.send(:default_playlists).first[:id]
            @response.last["title"].must_equal "Mixtapes"
          end
        end

        describe "local" do
          before do
            page.driver.submit :patch, "/provider/#{provider}/playlists/12345", {}
            visit "/provider/#{provider}/playlists"
            @response = Oj.load(page.body)
          end

          scenario do
            @response.size.must_equal @auth.client.playlists.size
            @response.first["id"].must_be_nil
            @response.last["id"].wont_be_nil
          end
        end
      end

      describe "update" do
        before do
          page.driver.submit :patch, "/provider/#{provider}/playlists/12345", {}
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
          visit "/provider/#{provider}/playlists/12345"
          @response = Oj.load(page.body)
        end

        scenario do
          @response["user_id"].must_equal @user.id
        end
      end
    end
  end
end
