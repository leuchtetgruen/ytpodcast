class VideoDownloader
  def initialize(video)
    @video = video
  end

  def run!
    mk_target_dir
    cmd = build_command
    system(cmd)
  end

  private
  def build_command
    #TODO adjust quality according to settings
    cmd = "youtube-dl "
    if @video.shouldOnlyKeepAudio?
      cmd += "-f 140 "
    else
      cmd += "-f 22 "
    end

    cmd += "--output #{@video.output_filename} " 
    cmd += @video.url

    p cmd

    cmd
  end

  def mk_target_dir
    unless Dir.exist?(@video.target_dir)
      Dir.mkdir(@video.target_dir)
    end
  end
end
