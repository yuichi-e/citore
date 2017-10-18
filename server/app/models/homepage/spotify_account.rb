# == Schema Information
#
# Table name: homepage_accounts
#
#  id                 :integer          not null, primary key
#  homepage_access_id :integer          not null
#  type               :string(255)
#  uid                :string(255)      not null
#  token              :text(65535)
#  token_secret       :text(65535)
#  expired_at         :datetime
#  options            :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_homepage_accounts_on_uid  (uid)
#  unique_homepage_accounts_index  (homepage_access_id,type) UNIQUE
#

class Homepage::SpotifyAccount < Homepage::Account
  def get_playlists
    return ApplicationRecord.request_and_parse_json(url: "https://api.spotify.com/v1/me/playlists", headers: {Authorization: "Bearer #{self.token}"})
  end

  # artist, playlist, track.
  def searches(text:, search_type: :track)
    #method: :get, params: {}, headers: {}
    return ApplicationRecord.request_and_parse_json(url: "https://api.spotify.com/v1/search", params: {q: text, type: search_type, limit: 50}, headers: {Authorization: "Bearer #{self.token}"})
  end

  #max 50件
  def tracks(ids: [])
    return ApplicationRecord.request_and_parse_json(url: "https://api.spotify.com/v1/tracks", params: {ids: ids.join(",")}, headers: {Authorization: "Bearer #{self.token}"})
  end

  def recommendations
    return ApplicationRecord.request_and_parse_json(url: "https://developer.spotify.com/web-api/get-recommendations/", headers: {Authorization: "Bearer #{self.token}"})
  end

  def audio_analysis(track_id:)
    return ApplicationRecord.request_and_parse_json(url: "https://api.spotify.com/v1/audio-analysis/#{track_id}", headers: {Authorization: "Bearer #{self.token}"})
  end

  def audio_features(track_id:)
    return ApplicationRecord.request_and_parse_json(url: "https://api.spotify.com/v1/audio-features/#{track_id}", headers: {Authorization: "Bearer #{self.token}"})
  end
end
