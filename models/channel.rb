require 'yt'

class Channel
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

  def desiredQuality
    @quality
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

  def shouldOnlyKeepAudio?
    @convert_to == SAVE_AUDIO
  end

  def id
    @ytChannel.id
  end

  def target_dir
    "data/#{id}"
  end

  def relative_public_url
    id
  end

  def author
    "Author unknown"
  end
end
