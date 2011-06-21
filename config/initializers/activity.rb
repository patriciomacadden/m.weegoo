class ActiveRecord::Base
  include ActionController::UrlWriter

  host = case Rails.env
    when "production"
      "weegoo.com.ar"
    when "development"
      "localhost:3000"
  end
  
  default_url_options[:host] = host
end