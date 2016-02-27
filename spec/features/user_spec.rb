require 'spec_helper'

RSpec.describe 'User CRUD', type: :feature do
  let(:username) { OmniAuth.config.mock_auth[:twitter].info.nickname }
  it 'Sign in with Twitter' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    click_button 'Create'

    expect(page.current_path).to eq('/')
    expect(page).to have_link('Logout')

    click_link username
    within '#content' do
      expect(page).to have_content(username, count: 4)
    end
  end

  it 'Create a new account with custom username' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    expect(page).to have_field('username', with: username)

    custom_name = 'Custom'
    custom_poj_user = 'Poj_C2'
    custom_aoj_user = 'Aoj_C2'
    custom_codeforces_user = 'Codeforces_C2'
    fill_in 'username', with: custom_name
    fill_in 'username at POJ', with: custom_poj_user
    fill_in 'username at AOJ', with: custom_aoj_user
    fill_in 'username at Codeforces', with: custom_codeforces_user
    expect { click_button 'Create' }.to change { User.count }.by(1)

    click_link custom_name
    expect(page).to have_content(custom_name)
    expect(page).to have_content(custom_poj_user)
    expect(page).to have_content(custom_aoj_user)
    expect(page).to have_content(custom_codeforces_user)
  end

  it 'Reject direct access to /users/new' do
    visit '/users/new'
    expect(page.current_path).to eq('/login')
  end

  context 'with duplication' do
    before do
      user = FactoryGirl.create(:user, name: username)
      FactoryGirl.create(:twitter_user, user: user)
    end

    it 'Try to create a new account but fail' do
      visit '/'
      click_link 'Login'
      click_link 'Sign in with Twitter'
      expect { click_button 'Create' }.to_not change { User.count }
      expect(page).to have_css('.alert', text: 'username')
    end

    it 'Create a new account with retry' do
      visit '/'
      click_link 'Login'
      click_link 'Sign in with Twitter'
      click_button 'Create'
      expect(page).to have_css('.alert', text: 'username')

      custom_name = 'Unique_User'
      fill_in 'username', with: custom_name
      expect { click_button 'Create' }.to change { User.count }.by(1)

      click_link custom_name
      within '#content' do
        expect(page).to have_content(custom_name, count: 1)
      end
    end
  end

  it 'Returns to the previous page after login' do
    visit '/contests/new'
    expect(page.current_path).to eq('/login')
    click_link 'Sign in with Twitter'
    click_button 'Create'
    expect(page.current_path).to eq('/contests/new')
  end

  it 'Edits an existing user' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    click_button 'Create'

    problem = '1234'
    auth = OmniAuth.config.mock_auth[:twitter]
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

    visit '/users/edit'
    expect(page).to have_field('username', with: username)
    expect(page).to have_field('username at POJ', with: username)
    expect(page).to have_field('username at AOJ', with: username)
    expect(page).to have_field('username at Codeforces', with: username)
    fill_in 'username', with: 'Next_User'
    fill_in 'username at POJ', with: 'POJ_Next'
    click_button 'Update'

    visit '/contests/NewContest'
    expect(page).to have_content('Next_User')
    expect(page).to have_content('WA')
    expect(page).not_to have_content('AC')
  end

  it 'Rejects invalid modification' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    click_button 'Create'

    visit '/users/edit'
    fill_in 'username', with: ''
    click_button 'Update'
    expect(page).to have_css('.alert')
    within('.alert') do
      expect(page).to have_content('username is invalid')
    end
  end

  it 'View username on each page' do
    visit '/'
    expect(page).to_not have_link(username)

    click_link 'Login'
    click_link 'Sign in with Twitter'
    click_button 'Create'

    visit '/'
    expect(page).to have_link(username)
  end

  it 'Edit Twitter link visibility' do
    visit '/'
    click_link 'Login'
    click_link 'Sign in with Twitter'
    click_button 'Create'

    click_link username
    expect(page).to_not have_link("@#{username}")

    click_link 'Edit profile'
    label = 'Display link to your Twitter account'
    expect(page).to have_unchecked_field(label)
    check label
    click_button 'Update'

    expect(page).to have_link("@#{username}")

    click_link 'Edit profile'
    expect(page).to have_checked_field(label)
  end
end
