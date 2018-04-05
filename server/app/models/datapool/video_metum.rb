# == Schema Information
#
# Table name: datapool_video_meta
#
#  id              :integer          not null, primary key
#  type            :string(255)
#  title           :string(255)      not null
#  front_image_url :text(65535)
#  data_category   :integer          default("file"), not null
#  bitrate         :integer          default(0), not null
#  origin_src      :string(255)      not null
#  query           :text(65535)
#  options         :text(65535)
#
# Indexes
#
#  index_datapool_video_meta_on_origin_src  (origin_src)
#  index_datapool_video_meta_on_title       (title)
#

class Datapool::VideoMetum < Datapool::ResourceMetum
  serialize :options, JSON

  VIDEO_FILE_EXTENSIONS = [
    #https://ja.wikipedia.org/wiki/Audio_Video_Interleave
    ".avi",
    #https://ja.wikipedia.org/wiki/Advanced_Systems_Format
    ".asf",".wma",".wmv",
    #https://ja.wikipedia.org/wiki/Flash_Video
    ".flv",".f4v",".f4p",".f4a",".f4b",
    #https://ja.wikipedia.org/wiki/Ogg_Media
    ".ogm",
    #https://ja.wikipedia.org/wiki/MPEG-1
    ".dat",".mpg",".mpeg",".m1v",
    #https://ja.wikipedia.org/wiki/MP4
    ".mp4",".m4v",".m4a",".m4p",
    #https://ja.wikipedia.org/wiki/QuickTime
    ".mov",
    #https://ja.wikipedia.org/wiki/RealVideo
    ".rm",".rmvb",".ram",
    #https://ja.wikipedia.org/wiki/XVD
    ".vg2",".vgm",
    #https://ja.wikipedia.org/wiki/Matroska
    ".mkv",".mka",".mks",".mk3d",
    #https://ja.wikipedia.org/wiki/3GPP#3GPP%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88
    ".3gp",
    #https://ja.wikipedia.org/wiki/WebM
    ".webm",
    ".swf"
  ]

  YOUTUBE_HOSTS = [
    "www.youtube.com",
    "youtu.be"
  ]

  NICONICO_VIDEO_HOSTS = [
    "www.nicovideo.jp"
  ]

  enum data_category: {
    file: 0,
    streaming: 1
  }

  CRAWL_VIDEO_ROOT_PATH = "project/crawler/videos/"

  def self.file_extensions
    return VIDEO_FILE_EXTENSIONS
  end

  def self.new_video(video_url:, title:, file_genre: , options: {})
    video_metum = self.new(
      title: title,
      data_category: file_genre,
      options: {
      }.merge(options)
    )
    video_metum.src = video_url
    if file_genre.blank?
      if self.streaming_site?(video_metum.src)
        video_metum.data_category = "streaming"
      else
        video_metum.data_category = "file"
      end
    end
    return video_metum
  end

  def self.videofile?(url)
    return VIDEO_FILE_EXTENSIONS.include?(File.extname(url)) || self.streaming_site?(url)
  end

  def self.streaming_site?(url)
    aurl = Addressable::URI.parse(url.to_s)
    return YOUTUBE_HOSTS.include?(aurl.host) || (NICONICO_VIDEO_HOSTS.include?(aurl.host) && aurl.path.include?("/watch"))
  end
end
