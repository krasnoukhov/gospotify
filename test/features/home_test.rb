require "test_helper"

feature "Home" do
  before do
    before_each
    visit "/"
  end

  scenario "has controls" do
    page.must_have_content("GoSpotify")
    page.must_have_link("Sign in with Spotify")
  end
end
