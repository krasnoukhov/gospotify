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

  describe "has playlists" do
    before do
      visit "/playlists/soundcloud"
    end

    scenario do
      page.body.must_equal "[\"omg\"]"
    end
  end
end
