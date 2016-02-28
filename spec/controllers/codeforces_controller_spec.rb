require 'spec_helper'

RSpec.describe CodeforcesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:tag1) { FactoryGirl.create(:tag, name: 'abc') }
  let(:tag2) { FactoryGirl.create(:tag, name: 'aba') }

  describe '#weekly' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:problem1) { '123A' }
    let(:problem2) { '114B' }
    let(:problem3) { '514C' }

    before do
      # Stabilize submission dates
      Timecop.travel(Time.zone.now.noon)

      # Non-weekly accepts are not counted.
      FactoryGirl.create(:codeforces_submission_ac, handle: user1.codeforces_user, problem_id: problem1, submission_time: 3.weeks.ago)
      FactoryGirl.create(:codeforces_submission_ac, handle: user2.codeforces_user, problem_id: problem1, submission_time: 2.weeks.ago)
      # Only accepts are counted.
      FactoryGirl.create(:codeforces_submission_wa, handle: user1.codeforces_user, problem_id: problem2, submission_time: 5.days.ago)
      FactoryGirl.create(:codeforces_submission_wa, handle: user1.codeforces_user, problem_id: problem3, submission_time: 4.days.ago)
      FactoryGirl.create(:codeforces_submission_ac, handle: user1.codeforces_user, problem_id: problem2, submission_time: 3.days.ago)
      FactoryGirl.create(:codeforces_submission_ac, handle: user1.codeforces_user, problem_id: problem1, submission_time: 3.days.ago)
      # Multiple accepts on the same problem are counted as one accept.
      FactoryGirl.create(:codeforces_submission_ac, handle: user2.codeforces_user, problem_id: problem3, submission_time: 2.days.ago)
      FactoryGirl.create(:codeforces_submission_ac, handle: user2.codeforces_user, problem_id: problem3, submission_time: 2.days.ago)
    end

    after do
      Timecop.return
    end

    it 'sets the number of weekly accepts' do
      xhr :get, :weekly
      expect(response).to be_ok
      expect(response).to render_template('codeforces/weekly')
      today = Date.current
      expect(assigns(:dates)).to eq(6.step(0, -1).map { |i| i.days.ago(today) })
      expect(assigns(:weekly)).to eq(
        user1.name => [0, 0, 0, 2, 0, 0, 0],
        user2.name => [0, 0, 0, 0, 1, 0, 0],
      )
    end
  end

  it_behaves_like 'a site problems controller'
end
