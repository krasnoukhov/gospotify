require "test_helper"

feature "Session" do
  after do
    visit "/auth/signout"
  end

  describe "success" do
    describe "spotify" do
      before do
        visit "/auth/spotify"
      end

      scenario "is logged in" do
        page.must_have_content("lol")
      end
    end
  end

  describe "failure" do
    before do
      @auth = OmniAuth.config.mock_auth[:spotify]
      OmniAuth.config.mock_auth[:spotify] = :invalid_credentials

      visit "/auth/spotify"
    end

    after do
      OmniAuth.config.mock_auth[:spotify] = @auth
    end

    scenario "displays failure" do
      page.must_have_content("OAuth error: invalid_credentials")
    end
  end
end
