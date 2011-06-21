module ApplicationHelper
  def title(page_title)
    content_for :title, page_title
  end
  
  def gravatar_url(email, size = 48, rating = 'g', default = nil)
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    
    if not size.nil? and size.between?(1, 512)
      params = "?s=#{size}"
    end
    
    if [ "g", "pg", "r", "x" ].include?(rating)
      params = params.nil? ? "?r=#{rating}" : "#{params}&r=#{rating}"
    end
    
    if not default.nil?
      params = params.nil? ? "?d=#{default}" : "#{params}&d=#{default}"
    end
    
    "http://gravatar.com/avatar/#{gravatar_id}.png#{params}"
  end
end
