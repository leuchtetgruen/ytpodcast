require 'yt'
require 'yaml'

$: << "."
require 'models/video.rb'
require 'models/channel.rb'
require 'models/cache.rb'

require 'tasks/video_downloader.rb'
require 'tasks/rss_creator.rb'

hash    = YAML.load_file('config.yml')
cache   = Cache.instance
baseURL = hash['base_url']

Yt.configuration.api_key = hash['api_key']

channels = hash['channels'].map do |channel_hash|
  Channel.new(channel_hash)
end

channels.each do |channel|
  puts "Processing channel #{channel.title}..."
  vids = channel.videos.select do |vid|
    !cache.has?(vid.id)
  end

  puts " * #{vids.size} new videos"
  vids.each do |vid|
    puts "   Downloading #{vid.title}..."
    
    vdl = VideoDownloader.new(vid)
    vdl.run!

    cache[vid.id] = vid.output_filename
    cache.save
  end

  puts " * Writing RSS..."

  rssCreator = RSSCreator.new(channel, baseURL)
  rssCreator.run!

  puts ""
end
#byebug
