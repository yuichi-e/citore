# == Schema Information
#
# Table name: crawl_target_urls
#
#  id                 :integer          not null, primary key
#  source_type        :string(255)      not null
#  crawl_from_keyword :string(255)
#  protocol           :string(255)      not null
#  host               :string(255)      not null
#  port               :integer
#  path               :string(255)      default(""), not null
#  query              :text(65535)      not null
#  crawled_at         :datetime
#  content_type       :string(255)
#  status_code        :integer
#  message            :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_crawl_target_urls_on_crawl_from_keyword          (crawl_from_keyword)
#  index_crawl_target_urls_on_crawled_at_and_status_code  (crawled_at,status_code)
#  index_crawl_target_urls_on_host_and_path               (host,path)
#

class CrawlTargetUrl < ApplicationRecord
  def self.setting_target!(target_class_name, url_string, from_keyword)
    url = Addressable::URI.parse(url_string)
    return CrawlTargetUrl.create!({
      source_type: target_class_name,
      crawl_from_keyword: from_keyword,
      protocol: url.scheme,
      host: url.host,
      path: url.path,
      query: url.query.to_s
    })
  end
end
