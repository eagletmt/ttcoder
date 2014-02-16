require 'spec_helper'

feature 'User CRUD' do
  scenario 'Sign in with Twitter' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'

    expect(page.current_path).to eq('/associate_user')
    expect(page).to have_field('prev_user')
    click_button 'No'

    expect(page.current_path).to eq('/')
    expect(page).to have_link('Logout')

    username = OmniAuth.config.mock_auth[:twitter].info.nickname
    visit "/users/#{username}"
    expect(page).to have_content(username)
  end

  scenario 'Sign in with Twitter and associate' do
    user = FactoryGirl.create(:user)

    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'

    expect(page.current_path).to eq('/associate_user')
    fill_in 'prev_user', with: user.name
    expect(page).to have_field('prev_user')
    expect(user.twitter_user).to be_nil
    click_button 'Associate'
    user.reload
    expect(user.twitter_user).not_to be_nil
    auth = OmniAuth.config.mock_auth[:twitter]
    expect(user.twitter_user.uid).to eq(auth.uid)

    expect(page.current_path).to eq('/')
    expect(page).to have_link('Logout')

    visit "/users/#{user.name}"
    expect(page).to have_content(user.name)
    expect(page).to have_content(auth.info.nickname)
  end

  scenario 'Sign in with Twitter and migrating to invalid user' do
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:twitter_user, user: user)

    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'

    expect(page.current_path).to eq('/associate_user')
    fill_in 'prev_user', with: user.name
    expect(page).to have_field('prev_user')
    expect { click_button 'Associate' }.not_to change { user.reload.twitter_user }
    expect(page.current_path).to eq('/associate_user')
    expect(page).to have_content('Already taken')
    expect(page).to have_content(user.name)
  end

  scenario 'Sign in with Twitter and skip migration' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    expect(page.current_path).to eq('/associate_user')
    expect(page).to have_field('prev_user')
    click_button 'No'

    click_link 'Logout'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    expect(page.current_path).to eq('/')
    expect(page).to have_content('Logout')
  end

  scenario 'Returns to the previous page after login' do
    visit '/contests/new'
    expect(page.current_path).to eq('/login')
    click_link 'Sign in with Twitter'
    click_button 'No'
    expect(page.current_path).to eq('/contests/new')
  end

  scenario 'Reject direct access to associate_user' do
    visit '/associate_user'
    expect(page.current_path).to eq('/login')
  end

  scenario 'Edits an existing user' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    click_button 'No'

    problem = '1234'
    auth = OmniAuth.config.mock_auth[:twitter]
    username = auth.info.nickname
    FactoryGirl.create(:poj_submission_ac, user: username, problem_id: problem)
    FactoryGirl.create(:poj_submission_wa, user: 'POJ_Next', problem_id: problem)
    contest = FactoryGirl.create(:contest, name: 'NewContest')
    contest.site_problems << FactoryGirl.create(:poj_problem, problem_id: problem)
    contest.users << TwitterUser.find(auth.uid).user
    contest.save!

    visit '/contests/NewContest'
    expect(page).to have_content(username)
    expect(page).to have_content('AC')
    expect(page).not_to have_content('WA')

    visit "/users/edit"
    expect(page).to have_field('username', with: username)
    expect(page).to have_field('username at POJ', with: username)
    expect(page).to have_field('username at AOJ', with: username)
    fill_in 'username', with: 'Next_User'
    fill_in 'username at POJ', with: 'POJ_Next'
    click_button 'Update'

    visit '/contests/NewContest'
    expect(page).to have_content('Next_User')
    expect(page).to have_content('WA')
    expect(page).not_to have_content('AC')
  end
end
