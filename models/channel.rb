require 'yt'

class Channel < VideoCollection

  def initialize(hash)
    super(hash)

    @ytChannel = Yt::Channel.new url:@url
  end

  def videos
    @ytChannel.videos.to_enum.to_a[0...@keep].map do |ytVideo|
      Video.new(ytVideo, self)
    end
  end
  
  def url
    "https://youtube.com/#{id}"
  end

  def title
    @ytChannel.title
  end

  def description
    @ytChannel.description
  end

  def thumbnail_url
    @ytChannel.thumbnail_url(:high)
  end

  def id
    @ytChannel.id
  end

  def author
    "Author unknown"
  end
end
