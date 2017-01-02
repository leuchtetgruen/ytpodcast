class VideoCollection
  SAVE_VIDEO = 1
  SAVE_AUDIO = 2

  def initialize(hash)
    @url = hash['url']
    @keep = hash['keep']
    @convert_to  = if hash['audio_only']
                     SAVE_AUDIO
                   else
                     SAVE_VIDEO
                   end

    @quality = case hash['quality'].to_s.downcase
               when "hi"
                 Video::QUALITY_HQ
               when "mid"
                 Video::QUALITY_MQ
               when "lo"
                 Video::QUALITY_LQ
               else
                 Video::QUALITY_HQ
               end
  end

  def videos
    raise NotImplementedError
  end

  def url
    raise NotImplementedError
  end

  def desiredQuality
    @quality
  end

  def title
    raise NotImplementedError
  end

  def description
    raise NotImplementedError
  end

  def thumbnail_url
    raise NotImplementedError
  end

  def shouldOnlyKeepAudio?
    @convert_to == SAVE_AUDIO
  end

  def id
    raise NotImplementedError
  end

  def target_dir
    "data/#{id}"
  end

  def relative_public_url
    id
  end

  def author
    raise NotImplementedError
  end

end
