module HomeHelper
  def link_to_twitter(name)
    link_to "@#{name}", "https://twitter.com/#{name}"
  end

  def simple_link_to(link)
    link_to link, link
  end
end
