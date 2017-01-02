# == Schema Information
#
# Table name: citore_voice_words
#
#  id           :integer          not null, primary key
#  word_type    :string(255)      not null
#  word_id      :integer          not null
#  speaker_name :string(255)      not null
#  file_name    :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  vioce_word_indexes  (word_type,word_id,speaker_name) UNIQUE
#

class Citore::VoiceWord < TwitterRecord

  VOICE_PARAMS = {
    ext: "wav",
    volume: 2.0,
    speed: 0.6,
    range: 2.0,
    pitch: 1.8,
    style: {"j" => "1.0"}
  }

  SUGARCOAT_VOICE_PARAMS = {
    ext: "aac",
    volume: 2.0,
    speed: 1.0,
    range: 1.0,
    pitch: 1.0,
    style: {"j" => "1.0"}
  }

  SUGARCOAT_VOICE_KEY = "sugarcoat"

  VOICE_FILE_ROOT = "/tmp/voices/"
  VOICE_S3_FILE_ROOT = "project/citore/voices/"
  VOICE_S3_SUGARCOAT_FILE_ROOT = "project/sugarcoat/voices/"

  def self.voice_file_root_path
    return Rails.root.to_s + VOICE_FILE_ROOT
  end

  def self.generate_and_upload_voice(text, keyword, speaker_name, acl = :private, options = {})
    apiconfig = YAML.load(File.open(Rails.root.to_s + "/config/apiconfig.yml"))
    params = VOICE_PARAMS.merge({
      username: apiconfig["aitalk"]["username"],
      password: apiconfig["aitalk"]["password"],
      text: text,
      speaker_name: speaker_name
    }).merge(options)
    file_name = "#{speaker_name}_" + SecureRandom.hex + "." + params[:ext]

    voice = VoiceDynamo.find(word: text, speaker_name: speaker_name, keyword: keyword)
    if voice.present?
      return voice
    end
    if voice.blank?
      voice = VoiceDynamo.new
      voice.uuid = SecureRandom.hex
      voice.keyword = keyword
    end
    voice.word = text
    voice.speaker_name = speaker_name    
    voice.file_name = file_name
    voice.generate_params = params
    voice.options = options

    http_client = HTTPClient.new
    response = http_client.get_content("http://webapi.aitalk.jp/webapi/v2/ttsget.php", params, {})
    
    s3 = Aws::S3::Client.new
    if keyword == SUGARCOAT_VOICE_KEY
      file_path = VOICE_S3_SUGARCOAT_FILE_ROOT + file_name
    else
      file_path = VOICE_S3_FILE_ROOT + file_name
    end
    s3.put_object(bucket: "taptappun",body: response,key: file_path, :acl => acl)
    voice.save!
    return voice
  end

  def self.all_speacker_names
    girl_speackers = ["nozomi", "sumire", "maki", "kaho", "akari", "nanako", "reina", "anzu", "chihiro", "miyabi_west", "aoi", "akane_west"]
    boy_speackers = ["seiji", "hiroshi", "osamu", "taichi", "koutarou", "yuuto", "yamato_west"]
    emo_girl_speackers = ["nozomi_emo", "maki_emo", "reina_emo"]
    emo_boy_speackers = ["taichi_emo"]
    speackers = girl_speackers + boy_speackers + emo_girl_speackers + emo_boy_speackers
    return speackers
  end
end