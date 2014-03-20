require 'spec_helper'

feature 'Tags' do
  given(:user) { FactoryGirl.create(:twitter_user).user }
  given!(:poj_problem) { FactoryGirl.create(:poj_problem, problem_id: '1000') }
  given!(:aoj_problem) { FactoryGirl.create(:aoj_problem, problem_id: '1000') }

  background do
    FactoryGirl.create(:tag, name: 'simple')
    FactoryGirl.create(:tag, name: 'dp')
    FactoryGirl.create(:tag, name: 'parsing')
  end

  scenario 'Create a new tag' do
    login :twitter, user
    visit '/poj/1000'
    click_link 'Edit tags'
    path = page.current_path
    fill_in 'tag_name', with: 'New_TagName'
    click_button 'Create'
    expect(page.current_path).to eq(path)
  end

  scenario 'Edit tags' do
    login :twitter, user
    visit '/poj/1000'
    expect(page).not_to have_link('simple')
    click_link 'Edit tags'
    expect(page).to have_content('POJ 1000')
    %w[simple dp parsing].each do |tag|
      expect(page).to have_field(tag, unchecked: true)
    end
    check 'simple'
    click_button 'Update tags'
    # FIXME: Move to controller spec
    activity = Activity.recent(1).first
    expect(activity).to be_tags_update
    expect(activity.user).to eq(user)
    expect(activity.target).to eq(poj_problem)
    expect(activity.parameters).to eq(Tag.where(name: %w[simple]).pluck(:id))

    expect(page.current_path).to eq('/poj/1000')
    expect(page).to have_link('simple')

    visit '/aoj/1000'
    expect(page).not_to have_link('simple')
    click_link 'Edit tags'
    expect(page).to have_content('AOJ 1000')
    %w[simple dp parsing].each do |tag|
      expect(page).to have_field(tag, unchecked: true)
    end
    check 'dp'
    check 'parsing'
    click_button 'Update tags'
    # FIXME: Move to controller spec
    activity = Activity.recent(1).first
    expect(activity).to be_tags_update
    expect(activity.user).to eq(user)
    expect(activity.target).to eq(aoj_problem)
    expect(activity.parameters).to eq(Tag.where(name: %w[dp parsing]).pluck(:id))

    expect(page.current_path).to eq('/aoj/1000')
    expect(page).to have_link('dp')
    expect(page).to have_link('parsing')

    visit '/poj/1000'
    click_link 'Edit tags'
    expect(page).to have_field('simple', unchecked: false)
    expect(page).to have_field('dp', unchecked: true)
    expect(page).to have_field('parsing', unchecked: true)

    visit '/aoj/1000'
    click_link 'Edit tags'
    expect(page).to have_field('simple', unchecked: true)
    expect(page).to have_field('dp', unchecked: false)
    expect(page).to have_field('parsing', unchecked: false)
  end

  scenario 'Show tagged problems' do
    poj_problem.tag_list = %w[simple]
    poj_problem.save!
    aoj_problem.tag_list = %w[simple dp]
    aoj_problem.save!

    visit '/'
    click_link 'Tags'
    expect(page).to have_link('simple (2)')
    expect(page).to have_link('dp (1)')
    expect(page).not_to have_link('parsing (0)')

    click_link 'simple (2)'
    expect(page).to have_link('POJ 1000')
    expect(page).to have_link('AOJ 1000')

    visit '/'
    click_link 'Tags'
    click_link 'dp (1)'
    expect(page).not_to have_link('POJ 1000')
    expect(page).to have_link('AOJ 1000')
  end

  scenario 'Create invalid tag name' do
    login :twitter, user
    visit '/poj/2000'
    click_link 'Edit tags'
    fill_in 'tag_name', with: 'a b c'
    path = page.current_path
    click_button 'Create'
    expect(page.current_path).to eq(path)
    expect(page).to have_css('.alert', text: 'Invalid tag name')
  end
end
