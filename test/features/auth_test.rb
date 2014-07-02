require "test_helper"

feature "Auth" do
  before do
    before_each
  end

  after do
    visit "/auth/signout"
  end

  describe "success" do
    describe "spotify" do
      before do
        visit "/auth/spotify"
      end

      scenario "is logged in" do
        page.must_have_content("john@smith.com")
        AuthRepository.all.count.must_equal 1
        UserRepository.all.count.must_equal 1
      end

      scenario "with the same auth" do
        visit "/auth/spotify"
        page.must_have_content("john@smith.com")
        AuthRepository.all.count.must_equal 1
        UserRepository.all.count.must_equal 1
      end
    end

    describe "soundcloud" do
      before do
        visit "/auth/spotify"
        visit "/auth/soundcloud"
      end

      scenario "is logged in" do
        AuthRepository.all.count.must_equal 2
        UserRepository.all.count.must_equal 1
      end
    end
  end

  describe "failure" do
    describe "oauth" do
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

    describe "email required" do
      before do
        visit "/auth/soundcloud"
      end

      scenario "displays failure" do
        page.must_have_content("OAuth error: email_required")
      end
    end

    describe "auth taken" do
      before do
        visit "/auth/spotify"
        visit "/auth/soundcloud"

        user = User.new(email: "noop@smith.com")
        UserRepository.create(user)
        page.set_rack_session(user_id: user.id)

        visit "/"
        visit "/auth/spotify"
      end

      scenario "displays failure" do
        page.must_have_content("OAuth error: auth_taken")
      end
    end
  end
end
