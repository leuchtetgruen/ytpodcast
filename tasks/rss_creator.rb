require 'rss'

class RSSCreator
  def initialize(channel, baseURL)
    @channel = channel
    @baseURL = baseURL
  end

  def run!
    rss = RSS::Maker.make("2.0") do |maker|
      rssChannel = make_channel(maker)

      make_image(maker)

      @channel.videos.each do |vid|
        item = make_item(vid, maker)
      end

    end

    write_rss(rss)
  end

  private
  def make_image(maker)
    maker.image.title = maker.channel.title
    maker.image.url = @channel.thumbnail_url
    maker.image.description = maker.channel.description
  end

  def make_channel(maker)
    maker.channel.title = @channel.title
    maker.channel.description = @channel.description
    maker.channel.link = @channel.url
    maker.channel.updated = Time.now.to_s
    maker.channel.author = @channel.author
    maker.channel.id = @channel.url

  end

  def make_item(video, maker)
    link = build_public_filename(video)

    maker.items.new_item do |item|
      item.title = video.title
      item.link = link
      item.summary = video.description
      item.description = video.description
      item.updated = video.published_at

      item.enclosure.url = item.link
      item.enclosure.length = File.size(video.output_filename)
      #TODO video type
      item.enclosure.type = "audio/mpeg4"


      #item.guid.isPermaLink = true
      #item.guid.content = link

    end
  end

  def build_public_filename(video)
    "#{@baseURL}/#{video.relative_public_url}"
  end

  def write_rss(rss)
    File.write("#{@channel.target_dir}/feed.rss", rss.to_s)
  end
end
