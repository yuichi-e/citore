# == Schema Information
#
# Table name: hackathon_sunflower_image_resources
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  url        :string(255)      not null
#  category   :integer          default(0), not null
#  state      :integer          not null
#  width      :integer          default(0), not null
#  height     :integer          default(0), not null
#  options    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_hackathon_sunflower_image_resources_on_user_id  (user_id)
#

class Hackathon::Sunflower::ImageResource < ApplicationRecord
  serialize :options, JSON
  belongs_to :user, class_name: 'Hackathon::Sunflower::User', foreign_key: :user_id, required: false
  has_many :worker_resources, class_name: 'Hackathon::Sunflower::WorkerResource', foreign_key: :resource_id
  has_many :workers, through: :worker_resources, source: :worker

  IMAGE_ROOT_PATH = "hackathon/sunflower/images/"

  enum cateogory: {
    ferry: 0,
    backgraound: 1,
    mixter: 2
  }

  enum state: {
    fix: 0,
    mutable: 1
  }

  def upload!(file)
    image = MiniMagick::Image.open(file.path)
    image.format(:png)
    filepath = IMAGE_ROOT_PATH + SecureRandom.hex + ".png"
    s3 = Aws::S3::Client.new
    s3.put_object(bucket: "taptappun",body: image.to_blob, key: filepath, acl: "public-read")
    update!(width: image.width, height: image.height, url: ApplicationRecord::S3_ROOT_URL + filepath)
  end
end