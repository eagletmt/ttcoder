require 'spec_helper'

feature 'Contest' do
  given(:user) { FactoryGirl.create(:user) }
  given(:contest) { FactoryGirl.create(:contest) }

  background do
    login :twitter, user
  end

  scenario 'Create a contest' do
    new_contest_name = '__CONTEST__'
    click_link 'New contest'
    fill_in 'contest_name', with: new_contest_name
    click_button 'Create'
    expect(page.current_path).to eq("/contests/#{new_contest_name}")
    expect(page).to have_content("Created by #{user.name}")

    click_link(user.name)
    expect(page).to have_link(new_contest_name)
  end

  scenario 'Join to and leave from a contest' do
    visit contest_path(contest)
    expect(page).to have_button('Join')
    expect(page).not_to have_button('Leave')
    expect(page).not_to have_content(user.name)

    click_button 'Join'

    expect(page).to have_content('Joined to')
    expect(page).not_to have_button('Join')
    expect(page).to have_button('Leave')
    expect(page).to have_content(user.name)

    click_button 'Leave'

    expect(page).to have_content('Left from')
    expect(page).to have_button('Join')
    expect(page).not_to have_button('Leave')
    expect(page).not_to have_content(user.name)
  end
end
