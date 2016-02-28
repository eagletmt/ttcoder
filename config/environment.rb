# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionView::Base.field_error_proc = lambda do |html_tag, _instance|
  # Disable emphasizes on error field
  html_tag
end
