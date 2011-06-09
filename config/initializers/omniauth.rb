Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "215573331810223", "6e23ebdc0ccb7f69bfe9a2fe28f21db9", { :scope => 'publish_stream,offline_access,email' }
  provider :twitter, "44wTPxCuHhamd4nBcDfmQ", "v8aeWS6DIw3IXlYVEZNY21SuopvdqIM3quqh6DALCyU"
end
