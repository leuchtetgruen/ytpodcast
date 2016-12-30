require 'yt'

class Video
  QUALITY_HQ = 1
  QUALITY_MQ = 2
  QUALITY_LQ = 3
  
  def initialize(ytVideo, channel)
    @ytVideo = ytVideo
    @channel = channel
  end

  def title
  end

  def description
    @ytVideo.description
  end

  def title
    @ytVideo.title
  end

  def thumbnail_url
    @ytVideo.thumbnail_url(:high)
  end

  def url
    "https://youtube.com/watch?v=#{id}"
  end

  def id
    @ytVideo.id
  end

  def quality
    @channel.desiredQuality
  end

  def shouldOnlyKeepAudio?
    @channel.shouldOnlyKeepAudio?
  end

  def channel
    @channel
  end
  
  def output_filename
    "#{target_dir}/#{id}.#{extension}"
  end

  def extension
    if shouldOnlyKeepAudio?
      "m4a"
    else
      "mp4"
    end
  end

  def target_dir
    @channel.target_dir
  end

  def relative_public_url
    "#{@channel.relative_public_url}/#{id}.#{extension}"
  end

  def published_at
    @ytVideo.published_at
  end
end
