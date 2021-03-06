require 'rss'

class RSSCreator
  def initialize(videoCollection, baseURL)
    @videoCollection = videoCollection
    @baseURL         = baseURL
  end

  def run!
    rss = RSS::Maker.make("2.0") do |maker|
      rssChannel = make_channel(maker)

      make_image(maker)

      @videoCollection.videos.each do |vid|
        item = make_item(vid, maker)
      end

    end

    write_rss(rss)
  end

  private
  def make_image(maker)
    maker.image.title = maker.channel.title
    maker.image.url = @videoCollection.thumbnail_url
    maker.image.description = maker.channel.description
  end

  def make_channel(maker)
    maker.channel.title = @videoCollection.title
    maker.channel.description = @videoCollection.description
    maker.channel.link = @videoCollection.url
    maker.channel.updated = Time.now.to_s
    maker.channel.author = @videoCollection.author
    maker.channel.id = @videoCollection.url
  end

  def make_item(video, maker)
    link = build_public_filename(video)
    filename = video.output_filename

    unless File.exist?(filename)
      # If the file does not exist dont try to put it in the RSS
      return
    end

    maker.items.new_item do |item|
      item.title = video.title
      item.link = link
      item.summary = video.description
      item.description = video.description
      item.updated = video.published_at

      item.enclosure.url = item.link
      item.enclosure.length = File.size(filename)
      item.enclosure.type = if video.shouldOnlyKeepAudio?
                              "audio/mpeg4"
                            else
                              "video/mp4"
                            end

      #item.guid.isPermaLink = true
      #item.guid.content = link
    end
  end

  def build_public_filename(video)
    "#{@baseURL}/#{video.relative_public_url}"
  end


  def write_rss(rss)
    File.write("#{@videoCollection.target_dir}/feed.rss", rss.to_s)
  end
end
