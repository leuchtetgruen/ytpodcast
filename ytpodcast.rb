require 'yt'
require 'yaml'
require 'byebug'

$: << "."
require 'models/video.rb'
require 'models/video_collection.rb'
require 'models/channel.rb'
require 'models/playlist.rb'
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

playlists = hash['playlists'].map do |playlist_hash|
  Playlist.new(playlist_hash)
end

videoCollections = (channels | playlists)


#TODO adjust to also playlists
videoCollections.each do |videoCollection|
  if videoCollection.is_a?(Channel)
    puts "Processing channel #{videoCollection.title}..."
  else
    puts "Processing playlist #{videoCollection.title}..."
  end

  vids = videoCollection.videos.select do |vid|
    !cache.has?(vid)
  end

  puts " * #{vids.size} new videos"
  vids.each do |vid|
    puts "   Downloading #{vid.title}..."
    
    begin
      vdl = VideoDownloader.new(vid)
      vdl.run!

      cache.add_video_filename(vid)
      cache.save
    rescue
      puts "   E: Could not download"
    end
  end

  puts " * Writing RSS..."

  rssCreator = RSSCreator.new(videoCollection, baseURL)
  rssCreator.run!

  puts ""
end
