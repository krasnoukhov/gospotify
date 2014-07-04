require "test_helper"

describe Syncer do
  before do
    playlist = Playlist.new
    PlaylistRepository.create(playlist)

    Syncer.new.perform(playlist.id)
  end

  it "performs" do
  end
end
