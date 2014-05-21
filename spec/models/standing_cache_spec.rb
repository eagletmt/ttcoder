require 'spec_helper'

RSpec.describe StandingCache, type: :model do
  let(:attributes) do
    {
      user: 'user001',
      problem_id: '1000',
      problem_type: 'poj',
      submitted_at: Time.local(2013, 10, 24),
      status: 'Accepted',
    }
  end

  describe '.update!' do
    it 'inserts a new record' do
      expect { StandingCache.update!(attributes) }.to change { StandingCache.count }.by(1)
    end

    context 'when previously accepted' do
      let!(:previous) do
        StandingCache.create!(attributes.merge(submitted_at: attributes[:submitted_at].yesterday))
      end

      it 'updates submitted_at if accepted' do
        expect { StandingCache.update!(attributes) }.to change { StandingCache.count }.by(0)
        previous.reload
        expect(previous.status).to eq('Accepted')
        expect(previous.submitted_at).to eq(attributes[:submitted_at])
      end

      it 'remains unless accepted' do
        expect { StandingCache.update!(attributes.merge(status: 'Wrong Answer')) }.to change { StandingCache.count }.by(0)
        previous.reload
        expect(previous.status).to eq('Accepted')
        expect(previous.submitted_at).to eq(attributes[:submitted_at].yesterday)
      end
    end

    context 'when previously failed' do
      let!(:previous) do
        StandingCache.create!(attributes.merge(status: 'Compile Error', submitted_at: attributes[:submitted_at].yesterday))
      end

      it 'updates if accepted' do
        expect { StandingCache.update!(attributes) }.to change { StandingCache.count }.by(0)
        previous.reload
        expect(previous.status).to eq('Accepted')
        expect(previous.submitted_at).to eq(attributes[:submitted_at])
      end

      it 'updates submitted_at even if fails' do
        expect { StandingCache.update!(attributes.merge(status: 'Wrong Answer')) }.to change { StandingCache.count }.by(0)
        previous.reload
        expect(previous.status).to eq('Wrong Answer')
        expect(previous.submitted_at).to eq(attributes[:submitted_at])
      end
    end

    context 'with uncached submissions' do
      let(:aoj_user) { 'New_User1' }
      let(:poj_user) { 'New_uSer2' }
      let(:aoj_problem) { '0123' }
      let(:poj_problem) { '3012' }

      before do
        PojSubmission.skip_callback(:save, :after, :update_standing_cache!)
        AojSubmission.skip_callback(:save, :after, :update_standing_cache!)

        FactoryGirl.create(:aoj_submission_ac, user_id: aoj_user, problem_id: aoj_problem)
        FactoryGirl.create(:poj_submission_wa, user: poj_user, problem_id: poj_problem)

        PojSubmission.set_callback(:save, :after, :update_standing_cache!)
        AojSubmission.set_callback(:save, :after, :update_standing_cache!)
      end

      it 'updates when new user is registered' do
        FactoryGirl.create(:user, poj_user: poj_user, aoj_user: aoj_user)
        expect(StandingCache.count).to eq(2)
        expect(StandingCache).to be_exist(user: aoj_user.downcase, problem_id: aoj_problem, problem_type: :aoj)
        expect(StandingCache).to be_exist(user: poj_user.downcase, problem_id: poj_problem, problem_type: :poj)
      end

      it 'updates when existing user is updated' do
        user = FactoryGirl.create(:user)
        user.poj_user = poj_user
        expect { user.save }.to change { StandingCache.count }.from(0).to(1)
      end
    end
  end
end
