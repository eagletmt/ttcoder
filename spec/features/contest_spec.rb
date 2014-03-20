require 'spec_helper'

feature 'Contest' do
  given(:contest) { FactoryGirl.create(:contest) }

  context 'with login user' do
    given(:user) { FactoryGirl.create(:twitter_user).user }

    background do
      login :twitter, user
    end

    scenario 'Create a contest' do
      new_contest_name = '__CONTEST__'
      click_link 'New contest'
      fill_in 'contest_name', with: new_contest_name
      click_button 'Create'
      expect(page.current_path).to eq("/contests/#{new_contest_name}")
      expect(page).to have_content("#{user.name} created contest #{new_contest_name}")

      within '#content' do
        click_link(user.name)
      end
      expect(page).to have_link(new_contest_name)
    end

    scenario 'Join to and leave from a contest' do
      visit contest_path(contest)
      within '#content' do
        expect(page).to have_button('Join')
        expect(page).not_to have_button('Leave')
        expect(page).not_to have_content(user.name)
      end

      click_button 'Join'

      within '#content' do
        expect(page).to have_content('Joined to')
        expect(page).not_to have_button('Join')
        expect(page).to have_button('Leave')
        expect(page).to have_content(user.name)
      end
      expect(page).to have_content("#{user.name} joined to contest #{contest.name}")

      click_button 'Leave'

      within '#content' do
        expect(page).to have_content('Left from')
        expect(page).to have_button('Join')
        expect(page).not_to have_button('Leave')
        within '#standing' do
          expect(page).not_to have_content(user.name)
        end
      end
      expect(page).to have_content("#{user.name} left contest #{contest.name}")
    end
  end

  scenario 'Reload standing', :js do
    problem = FactoryGirl.create(:poj_problem)

    visit contest_path(contest)
    expect(page).not_to have_link(problem.description)

    contest.site_problems << problem
    contest.save!

    click_link 'Reload'
    expect(page).to have_link(problem.description)
  end

  context 'with short reload interval' do
    given(:interval) { 3.seconds }

    before do
      ContestsController.class_eval {}  # autoload first
      stub_const('ContestsController::STANDING_RELOAD_INTERVAL', interval)
    end

    scenario 'Automatic standing reload', :js do
      problem = FactoryGirl.create(:poj_problem)

      visit contest_path(contest)
      expect(page).not_to have_link(problem.description)

      contest.site_problems << problem
      contest.save!

      sleep interval
      expect(page).to have_link(problem.description)
    end
  end
end
