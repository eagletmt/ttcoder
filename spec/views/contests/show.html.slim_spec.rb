require 'spec_helper'

RSpec.describe 'contests/show', type: :view do
  let(:t1) { Time.parse '2013-06-04 10:00' }
  let(:t2) { Time.parse '2013-06-04 12:00' }
  let(:t3) { Time.parse '2013-06-04 14:00' }
  let(:users) { [FactoryGirl.create(:user, name: 'Stern', poj_user: 'Stern')] }
  let(:problems) { [FactoryGirl.create(:poj_problem, problem_id: '4000')] }

  before do
    assign :users, users
    assign :problems, problems
  end

  context 'when the latest submission is after contest creation' do
    it 'does not render with .old' do
      assign :contest, FactoryGirl.create(:contest, users: users, name: 'Unbreakable Dark', site_problems: problems, created_at: t2)
      standing = {
        'Stern' => {
          'POJ 4000' => { status: 'AC', submitted_at: t3 },
        },
      }
      scores = {
        'Stern' => 360.0,
      }
      assign :standing, standing
      assign :scores, scores
      assign :activities, []
      render
      expect(rendered).to have_selector('.grid-table .ac')
      expect(rendered).not_to have_selector('.grid-table .ac.old')
    end
  end

  context 'when the latest submission is before contest creation' do
    it 'renders with .old' do
      assign :contest, FactoryGirl.create(:contest, users: users, name: 'Unbreakable Dark', site_problems: problems, created_at: t2)
      standing = {
        'Stern' => {
          'POJ 4000' => { status: 'AC', submitted_at: t1 },
        },
      }
      scores = {
        'Stern' => 360.0,
      }
      assign :standing, standing
      assign :scores, scores
      assign :activities, []
      render
      expect(rendered).to have_selector('.grid-table .ac.old')
    end
  end
end
