# == Schema Information
#
# Table name: datapool_image_meta
#
#  id                :bigint(8)        not null, primary key
#  type              :string(255)
#  title             :string(255)      not null
#  original_filename :string(255)
#  origin_src        :string(255)      not null
#  other_src         :text(65535)
#  options           :text(65535)
#
# Indexes
#
#  index_datapool_image_meta_on_origin_src  (origin_src)
#  index_datapool_image_meta_on_title       (title)
#

class Datapool::NiconicoImageMetum < Datapool::ImageMetum
  NICONICO_CONTENT_API_URL = "http://api.search.nicovideo.jp/api/v2/illust/contents/search"

  def self.crawl_images!(keyword:)
    all_images = []
    counter = 0
    loop do
      images = []
      json = RequestParser.request_and_parse_json(url: NICONICO_CONTENT_API_URL, params: {q: keyword, targets: "title,description,tags", _context: "taptappun", fields: "contentId,title,tags,categoryTags,thumbnailUrl", _sort: "-startTime", _offset: counter, _limit: 100})
      json["data"].each do |data_hash|
        image = self.constract(
          url: data_hash["thumbnailUrl"],
          title: data_hash["title"],
          options: {
            keywords: keyword.to_s,
            content_id: data_hash["contentId"],
            tags: data_hash["tags"].to_s.split(" "),
            category_tags: data_hash["categoryTags"].to_s.split(" ")
          }
        )
        images << image
      end
      break if images.blank?
      self.import_resources!(resources: images)
      all_images += images
      counter = counter + images.size
      break if json["meta"]["totalCount"].to_i <= counter
    end
    return all_images
  end
end
