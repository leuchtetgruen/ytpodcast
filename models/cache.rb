require 'json'

class Cache

  include Singleton

  def initialize(filename="cache.json")
    @filename = filename
    load
  end

  def load
    @hash = if File.exist?(@filename)
             JSON.parse(File.read(@filename))
           else
             {}
           end
  end

  def save
    File.write(@filename, @hash.to_json)
  end

  def video_filename(video)
    key = hash_key(video)
    (@hash[key] or video.output_filename)
  end

  def add_video_filename(video)
    key = hash_key(video)
    @hash[key] = video.output_filename
  end

  def has?(video)
    key = hash_key(video)
    @hash.keys.map(&:to_s).include?(key)
  end

  private
  def hash_key(video)
    vc = video.videoCollection
    
    key = if vc.is_a?(Playlist)
            "P-"
          elsif vc.is_a?(Channel)
            "C-"
          else
            "U-"
          end
    
    key += video.id

    key += if video.shouldOnlyKeepAudio?
             "-A"
           else
             "-V"
           end

    #TODO consider quality

    key
  end
end
