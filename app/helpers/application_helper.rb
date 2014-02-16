module ApplicationHelper
  def format_title(title)
    t = 'Tokyo Tech Coder'
    title.blank? ? t : "#{t} - #{title}"
  end

  def partial_exists?(name)
    lookup_context.template_exists? name, lookup_context.prefixes, true
  end
end
