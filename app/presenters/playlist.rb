class PlaylistPresenter
  def initialize(playlist)
    @playlist = playlist
  end

  def to_h
    {
      "id"           => @playlist.id,
      "user_id"      => @playlist.user_id,
      "provider"     => @playlist.provider,
      "external_id"  => @playlist.external_id,
      "title"        => @playlist.title,
      "job_id"       => @playlist.job_id,
      "synced_at"    => @playlist.synced_at ? @playlist.synced_at.iso8601 : nil,
      "status"       => @playlist.status,
    }
  end
end
