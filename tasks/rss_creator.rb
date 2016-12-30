require 'rss'

class RSSCreator
  def initialize(channel, baseURL)
    @channel = channel
    @baseURL = baseURL
  end

  def run!
    rss = RSS::Maker.make("2.0") do |maker|
      rssChannel = make_channel(maker)

      @channel.videos.each do |vid|
        item = make_item(vid, maker)
      end

    end

    write_rss(rss)
  end

  private
  def make_channel(maker)
    maker.channel.title = @channel.title
    maker.channel.description = @channel.description
    maker.channel.link = @channel.url
    maker.channel.updated = Time.now.to_s
    maker.channel.author = @channel.author
    maker.channel.id = @channel.url

    #maker.channel.image = RSS:Rss::Channel::Image.new
    #maker.channel.image.url = @channel.preview_url
    #maker.channel.image.title = channel.title
    #maker.channel.image.link = channel.link
  end

  def make_item(video, maker)
    link = build_public_filename(video)

    maker.items.new_item do |item|
      item.title = video.title
      item.link = link
      item.description = video.description
      item.updated = video.published_at

      item.enclosure.url = item.link
      item.enclosure.length = File.size(video.output_filename)
      item.enclosure.type = "audio/mp4"

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
