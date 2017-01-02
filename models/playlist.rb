require 'yt'

require 'yt'

class Playlist < VideoCollection
  attr_accessor :ytPlaylist

  def initialize(hash)
    super(hash)

    @ytPlaylist = Yt::Playlist.new url:@url
  end

  def videos
    @ytPlaylist.playlist_items.to_enum.to_a[0...@keep].map do |playlistItem|
      Video.new(playlistItem.video, self)
    end
  end

  def id
    @ytPlaylist.id
  end

  def title
    @ytPlaylist.title
  end

  def description
    @ytPlaylist.description
  end

  def url
    "https://www.youtube.com/playlist?list=#{id}"
  end

  def author
    @ytPlaylist.channel_title
  end

  def thumbnail_url
    @ytPlaylist.thumbnail_url(:high)
  end

end
