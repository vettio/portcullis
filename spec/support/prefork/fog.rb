require 'fog'

Fog.mock!
Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
