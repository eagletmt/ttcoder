require 'spec_helper'

describe PojController do
  let(:user) { FactoryGirl.create(:user) }
  let(:tag1) { FactoryGirl.create(:tag, name: 'abc') }
  let(:tag2) { FactoryGirl.create(:tag, name: 'aba') }

  describe '#weekly' do
    let(:user1) { user }
    let(:user2) { FactoryGirl.create(:user) }
    let(:problem1) { '0314' }
    let(:problem2) { '1592' }
    let(:problem3) { '6535' }

    before do
      # Non-weekly accepts are not counted.
      FactoryGirl.create(:poj_submission_ac, user: user1.poj_user, problem_id: problem1, submitted_at: 3.weeks.ago)
      FactoryGirl.create(:poj_submission_ac, user: user2.poj_user, problem_id: problem1, submitted_at: 2.weeks.ago)
      # Only accepts are counted.
      FactoryGirl.create(:poj_submission_wa, user: user1.poj_user, problem_id: problem2, submitted_at: 5.days.ago)
      FactoryGirl.create(:poj_submission_wa, user: user1.poj_user, problem_id: problem3, submitted_at: 4.days.ago)
      FactoryGirl.create(:poj_submission_ac, user: user1.poj_user, problem_id: problem2, submitted_at: 3.days.ago)
      FactoryGirl.create(:poj_submission_ac, user: user1.poj_user, problem_id: problem1, submitted_at: 3.days.ago)
      # Multiple accepts on the same problem are counted as one accept.
      FactoryGirl.create(:poj_submission_ac, user: user2.poj_user, problem_id: problem3, submitted_at: 2.days.ago)
      FactoryGirl.create(:poj_submission_ac, user: user2.poj_user, problem_id: problem3, submitted_at: 2.days.ago)
    end

    it 'sets the number of weekly accepts' do
      xhr :get, :weekly
      expect(response).to be_ok
      expect(response).to render_template('poj/weekly')
      today = Date.today
      expect(assigns(:dates)).to eq(6.step(0, -1).map { |i| i.days.ago(today) })
      expect(assigns(:weekly)).to eq({
        user1.name => [0, 0, 0, 2, 0, 0, 0],
        user2.name => [0, 0, 0, 0, 1, 0, 0],
      })
    end
  end

  it_behaves_like 'a site problems controller'
end
