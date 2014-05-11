require 'spec_helper'

RSpec.describe 'Contest edition' do
  let(:user) { FactoryGirl.create(:twitter_user).user }
  let!(:contest) { FactoryGirl.create(:contest, name: 'ayakashi') }
  let!(:poj4000) { FactoryGirl.create(:poj_problem, problem_id: '4000') }
  let!(:poj3000) { FactoryGirl.create(:poj_problem, problem_id: '3000') }
  let!(:aoj4000) { FactoryGirl.create(:aoj_problem, problem_id: '4000') }

  before do
    contest.users << FactoryGirl.create(:twitter_user).user << FactoryGirl.create(:twitter_user).user
    contest.site_problems << poj3000 << aoj4000

    login :twitter, user
  end

  it 'Update message' do
    visit '/'
    click_link contest.name

    new_message = '__NEW_MESSAGE__'
    expect(page).to_not have_content(new_message)
    click_link 'Edit this contest'

    fill_in 'contest_message', with: new_message
    click_button 'Update'

    expect(page).to have_content(new_message)
    expect(page).to have_content("#{user.name} updated contest #{contest.name}")
  end

  it 'Add a problem' do
    visit '/'
    click_link contest.name

    expect(page).to have_content(poj3000.description)
    expect(page).to have_content(aoj4000.description)
    expect(page).not_to have_content(poj4000.description)
    click_link 'Edit this contest'

    choose 'AOJ'
    fill_in 'problem_problem_id', with: '1234'
    click_button 'Add problem'
    click_link 'Back'

    expect(page).to have_content(poj3000.description)
    expect(page).to have_content(aoj4000.description)
    expect(page).to have_content('AOJ 1234')
  end

  it 'Add a problem with empty problem_id' do
    visit '/'
    click_link contest.name
    click_link 'Edit this contest'

    choose 'AOJ'
    fill_in 'problem_problem_id', with: ''
    path = page.current_path
    expect { click_button 'Add problem' }.not_to change { contest.reload.site_problems.count }
    expect(page.current_path).to eq(path)
    expect(page).to have_content('Invalid problem')
  end

  it 'Failed to add a problem with non-numeric problem_id' do
    visit '/'
    click_link contest.name
    click_link 'Edit this contest'

    choose 'POJ'
    fill_in 'problem_problem_id', with: 'POJ3264'
    path = page.current_path
    expect { click_button 'Add problem' }.not_to change { contest.reload.site_problems.count }
    expect(page.current_path).to eq(path)
    expect(page).to have_content('Invalid problem')
  end

  it 'Remove a problem' do
    visit '/'
    click_link contest.name

    expect(page).to have_content(poj3000.description)
    expect(page).to have_content(aoj4000.description)
    expect(page).not_to have_content(poj4000.description)
    click_link 'Edit this contest'

    within('li', text: poj3000.description) do
      click_link 'Remove'
    end
    click_link 'Back'

    expect(page).not_to have_content(poj3000.description)
    expect(page).to have_content(aoj4000.description)
    expect(page).not_to have_content(poj4000.description)
  end

  it 'Up-down a problem' do
    contest.site_problems << poj4000

    visit '/'
    click_link contest.name

    # Order: poj3000 -> aoj4000 -> poj4000
    e1 = find('.column', text: poj3000.description)
    expect(page).to have_xpath("#{e1.path}/following-sibling::*", text: aoj4000.description)
    e2 = find(:xpath, "#{e1.path}/following-sibling::*", text: aoj4000.description)
    expect(page).to have_xpath("#{e2.path}/following-sibling::*", text: poj4000.description)
    click_link 'Edit this contest'

    within('li', text: aoj4000.description) do
      click_link 'Down'
    end
    # Order: poj3000 -> poj4000 -> aoj4000
    within('li', text: poj4000.description) do
      click_link 'Up'
    end
    click_link 'Back'

    # Order: poj4000 -> poj3000 -> aoj4000
    e1 = find('.column', text: poj4000.description)
    expect(page).to have_xpath("#{e1.path}/following-sibling::*", text: poj3000.description)
    e2 = find(:xpath, "#{e1.path}/following-sibling::*", text: poj3000.description)
    expect(page).to have_xpath("#{e1.path}/following-sibling::*", text: aoj4000.description)
  end
end
