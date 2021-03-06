module ModelHelpers
  def oauth_hash(provider_name = :developer)
    OmniAuth::AuthHash.new({
      uid:          Random.rand(Time.now.to_i),
      provider:     provider_name.to_s,
      info:         OmniAuth::AuthHash::InfoHash.new({
        first_name:  Faker::Name.first_name,
        last_name:   Faker::Name.last_name,
        name:        Faker::Internet.user_name,
        nickname:    Faker::Internet.user_name,
        email:       Faker::Internet.email,
        location:    Faker::Address.street_address
      }),
      credentials:  { 
        token:       Digest::SHA256.hexdigest("#{Time.now.to_s}#{Faker::Internet.user_name}"),
        secret:      Digest::SHA256.hexdigest("#{Time.now.to_s}#{Faker::Lorem.sentence}")
      }
    })
  end
end
