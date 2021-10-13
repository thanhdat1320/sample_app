module UsersHelper
  def gravatar_for user, options = {size: Settings.validations.length.size_80}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url =
      "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def is_admin? user
    current_user.admin? && !current_user?(user)
  end
end
