require 'yt'

class Video
  QUALITY_HQ = 1
  QUALITY_MQ = 2
  QUALITY_LQ = 3
  
  def initialize(ytVideo, videoCollection)
    @ytVideo         = ytVideo
    @videoCollection = videoCollection
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
    @videoCollection.desiredQuality
  end

  def shouldOnlyKeepAudio?
    @videoCollection.shouldOnlyKeepAudio?
  end

  def videoCollection 
    @videoCollection
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
    @videoCollection.target_dir
  end

  def relative_public_url
    "#{@videoCollection.relative_public_url}/#{id}.#{extension}"
  end

  def published_at
    @ytVideo.published_at
  end

  def videoCollection
    @videoCollection
  end
end
