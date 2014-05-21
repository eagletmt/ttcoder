require 'spec_helper'

RSpec.describe 'Activity', type: :feature do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }

  before do
    FactoryGirl.create(:poj_submission_ac, user: user1.poj_user)
    FactoryGirl.create(:aoj_submission_wa, user_id: user2.aoj_user)
    FactoryGirl.create(:contest, owner: user1)
  end

  it 'list recent activities' do
    visit '/activities'
    expect(page).to have_content("#{user1.name} submitted")
    expect(page).to have_link('AC')
    expect(page).to have_content("#{user2.name} submitted")
    expect(page).to have_link('WA')
    expect(page).to have_content("#{user1.name} created contest")
  end
end
