module LoginHelper
  def login(provider, user)
    visit auth_path(provider)
    fill_in 'prev_user', with: user.name
    click_button 'Associate'
  end
end

RSpec.configure do |config|
  config.include(LoginHelper, type: :feature)
end
