class User < ActiveRecord::Base
  def self.from_omniauth(auth)
    user = find_or_create_by(uid: auth["uid"], provider: auth["provider"])
    user.provider = auth.provider
    user.uid = auth.uid
    user.name = auth.info.name
    user.email = auth.info.email
    user.image = auth.info.image
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.save!
    user
  end
end
