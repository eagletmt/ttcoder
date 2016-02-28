require 'spec_helper'

RSpec.describe CodeforcesSubmission, type: :model do
  describe '#save' do
    it 'saves' do
      sub = FactoryGirl.build :codeforces_submission_ac
      expect { sub.save }.to change { described_class.count }.by 1
    end

    it 'requires handle' do
      sub = FactoryGirl.build :codeforces_submission_ac, handle: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires problem_id' do
      sub = FactoryGirl.build :codeforces_submission_ac, problem_id: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires submission_time' do
      sub = FactoryGirl.build :codeforces_submission_ac, submission_time: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires valid verdict' do
      sub = FactoryGirl.build :codeforces_submission_ac, verdict: 'UNKNOWN'
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires time_consumed_millis' do
      sub = FactoryGirl.build :codeforces_submission_ac, time_consumed_millis: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'allows time_consumed_millis to be -1' do
      sub = FactoryGirl.build :codeforces_submission_ac, time_consumed_millis: -1
      expect { sub.save }.to change { described_class.count }.by 1
    end

    it 'requires memory_consumed_bytes' do
      sub = FactoryGirl.build :codeforces_submission_ac, memory_consumed_bytes: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    context 'with user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'creates activity' do
        sub = FactoryGirl.build(:codeforces_submission_ac, handle: user.codeforces_user)
        expect { sub.save }.to change { Activity.count }.by(1)
        activity = Activity.recent(1).first
        expect(activity).to be_submission_create
        expect(activity.user).to eq(user)
        expect(activity.target).to eq(sub)
      end
    end
  end

  describe '.user' do
    it 'is case-insensitive' do
      FactoryGirl.create(:codeforces_submission_ac, handle: 'Foo_Bar')
      FactoryGirl.create(:codeforces_submission_ac, handle: 'fOO_Bar')
      FactoryGirl.create(:codeforces_submission_ac, handle: 'barBaz')
      expect(described_class.user('foo_bar').count).to eq(2)
      expect(described_class.user(%w[foo_bar barbaz]).count).to eq(3)
    end
  end

  describe '.between' do
    let(:t1) { Time.parse '2013-06-04 18:00' }
    let(:t2) { Time.parse '2013-06-04 20:00' }
    let(:t3) { Time.parse '2013-06-05 00:00' }
    let(:t4) { Time.parse '2013-06-05 08:00' }

    before do
      FactoryGirl.create(:codeforces_submission_ac, submission_time: t1)
      FactoryGirl.create(:codeforces_submission_wa, submission_time: t2)
      FactoryGirl.create(:codeforces_submission_ac, submission_time: t3)
      FactoryGirl.create(:codeforces_submission_ac, submission_time: t4)
    end

    context 'with Time' do
      it 'returns submissions in given range' do
        subs = described_class.between Time.parse('2013-06-04 19:00'), Time.parse('2013-06-05 01:00')
        expect(subs.size).to eq(2)
        expect(subs[0].submission_time).to eq t2
        expect(subs[1].submission_time).to eq t3
      end
    end

    context 'with Date' do
      it 'returns submissions in given range' do
        subs = described_class.between Date.parse('2013-06-04'), Time.parse('2013-06-05')
        expect(subs.size).to eq(2)
        expect(subs[0].submission_time).to eq t1
        expect(subs[1].submission_time).to eq t2
      end
    end
  end

  describe '.standing' do
    let(:u1) { FactoryGirl.create :user }
    let(:u2) { FactoryGirl.create :user }
    let(:p1) { '10A' }
    let(:p2) { '123B' }
    let(:p3) { '777E' }
    let(:t1) { Time.parse '2013-06-04 17:30' }
    let(:t2) { Time.parse '2013-06-04 18:00' }

    before do
      FactoryGirl.create(:codeforces_submission_ac, problem_id: p1, handle: u1.codeforces_user)
      FactoryGirl.create(:codeforces_submission_wa, problem_id: p1, handle: u2.codeforces_user, submission_time: t1)
      FactoryGirl.create(:codeforces_submission_ac, problem_id: p1, handle: u2.codeforces_user, submission_time: t2)
      FactoryGirl.create(:codeforces_submission_wa, problem_id: p2, handle: u1.codeforces_user)
      FactoryGirl.create(:codeforces_submission_ac, problem_id: p3, handle: u2.codeforces_user)
    end

    it 'returns standing' do
      h = described_class.standing([u1, u2], [p1, p2])
      expect(h).to be_a Hash
      expect(h.keys.sort).to eq [u1.name, u2.name].sort
      h.values.each do |h2|
        expect(h2.keys.sort).to eq [p1, p2].sort
      end
      expect(h[u1.name][p1][:status]).to eq 'AC'
      expect(h[u2.name][p1][:status]).to eq 'AC'
      expect(h[u1.name][p2][:status]).to eq 'WA'
      expect(h[u2.name][p2]).to be_nil
    end
  end

  describe '.solved_users' do
    let(:u1) { FactoryGirl.create(:user) }
    let(:u2) { FactoryGirl.create(:user) }
    let(:u3) { FactoryGirl.create(:user) }
    let(:p1) { '10A' }
    let(:p2) { '200A' }

    before do
      2.times { FactoryGirl.create(:codeforces_submission_ac, problem_id: p1, handle: u1.codeforces_user) }
      FactoryGirl.create(:codeforces_submission_wa, problem_id: p1, handle: u2.codeforces_user)
      FactoryGirl.create(:codeforces_submission_wa, problem_id: p2, handle: u1.codeforces_user)
      FactoryGirl.create(:codeforces_submission_ac, problem_id: p1, handle: u3.codeforces_user)
    end

    it 'returns users who solve this problem' do
      expect(described_class.solved_users(p1)).to match_array([u1, u3])
      expect(described_class.solved_users(p2)).to be_empty
    end
  end

  describe '.recent' do
    let!(:s1) { FactoryGirl.create(:codeforces_submission_ac, submission_time: 5.weeks.ago) }
    let!(:s2) { FactoryGirl.create(:codeforces_submission_ac, submission_time: 3.weeks.ago) }
    let!(:s3) { FactoryGirl.create(:codeforces_submission_ac, submission_time: 2.weeks.ago) }
    it 'returns submissions in 1 month in submission_time order' do
      subs = described_class.recent
      expect(subs).to eq([s3, s2])
    end
  end
end
