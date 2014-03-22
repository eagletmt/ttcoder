require 'spec_helper'

feature 'Activity' do
  given(:user1) { FactoryGirl.create(:user) }
  given(:user2) { FactoryGirl.create(:user) }

  background do
    FactoryGirl.create(:poj_submission_ac, user: user1.poj_user)
    FactoryGirl.create(:aoj_submission_wa, user_id: user2.aoj_user)
    FactoryGirl.create(:contest, owner: user1)
  end

  scenario 'list recent activities' do
    visit '/activities'
    expect(page).to have_content("#{user1.name} submitted")
    expect(page).to have_link('AC')
    expect(page).to have_content("#{user2.name} submitted")
    expect(page).to have_link('WA')
    expect(page).to have_content("#{user1.name} created contest")
  end
end
