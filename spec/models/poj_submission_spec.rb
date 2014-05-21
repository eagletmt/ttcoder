require 'spec_helper'

RSpec.describe PojSubmission, type: :model do
  describe '#save' do
    it 'saves' do
      sub = FactoryGirl.build :poj_submission_ac
      expect { sub.save }.to change { described_class.count }.by 1
    end

    it 'requires user' do
      sub = FactoryGirl.build :poj_submission_ac, user: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires problem_id' do
      sub = FactoryGirl.build :poj_submission_ac, problem_id: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires valid result' do
      sub = FactoryGirl.build :poj_submission_ac, result: 'UNKNOWN'
      expect { sub.save }.not_to change { described_class.count }
    end

    context 'with AC' do
      it 'requires memory' do
        sub = FactoryGirl.build :poj_submission_ac, memory: ''
        expect { sub.save }.not_to change { described_class.count }
      end

      it 'requires time' do
        sub = FactoryGirl.build :poj_submission_ac, time: ''
        expect { sub.save }.not_to change { described_class.count }
      end
    end

    context 'with WA' do
      it 'allows memory to be blank' do
        sub = FactoryGirl.build :poj_submission_wa, memory: ''
        expect { sub.save }.to change { described_class.count }.by 1
      end

      it 'allows time to be blank' do
        sub = FactoryGirl.build :poj_submission_wa, time: ''
        expect { sub.save }.to change { described_class.count }.by 1
      end
    end

    it 'requires valid language' do
      sub = FactoryGirl.build :poj_submission_ac, language: 'Haskell'
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires length' do
      sub = FactoryGirl.build :poj_submission_ac, length: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    it 'requires submitted_at' do
      sub = FactoryGirl.build :poj_submission_ac, submitted_at: ''
      expect { sub.save }.not_to change { described_class.count }
    end

    context 'with user' do
      let(:user) { FactoryGirl.create(:user) }

      it 'creates activity' do
        sub = FactoryGirl.build(:poj_submission_ac, user: user.poj_user)
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
      FactoryGirl.create :poj_submission_ac, user: 'Foo_Bar'
      FactoryGirl.create :poj_submission_ac, user: 'fOO_Bar'
      FactoryGirl.create :poj_submission_ac, user: 'barBaz'
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
      FactoryGirl.create :poj_submission_ac, submitted_at: t1
      FactoryGirl.create :poj_submission_wa, submitted_at: t2
      FactoryGirl.create :poj_submission_ac, submitted_at: t3
      FactoryGirl.create :poj_submission_ac, submitted_at: t4
    end

    context 'with Time' do
      it 'returns submissions in given range' do
        subs = described_class.between Time.parse('2013-06-04 19:00'), Time.parse('2013-06-05 01:00')
        expect(subs.size).to eq(2)
        expect(subs[0].submitted_at).to eq t2
        expect(subs[1].submitted_at).to eq t3
      end
    end

    context 'with Date' do
      it 'returns submissions in given range' do
        subs = described_class.between Date.parse('2013-06-04'), Time.parse('2013-06-05')
        expect(subs.size).to eq(2)
        expect(subs[0].submitted_at).to eq t1
        expect(subs[1].submitted_at).to eq t2
      end
    end
  end

  describe '.standing' do
    let(:u1) { FactoryGirl.create :user }
    let(:u2) { FactoryGirl.create :user }
    let(:p1) { 1000 }
    let(:p2) { 2000 }
    let(:p3) { 3000 }
    let(:t1) { Time.parse '2013-06-04 17:30' }
    let(:t2) { Time.parse '2013-06-04 18:00' }

    before do
      FactoryGirl.create(:poj_submission_ac, problem_id: p1, user: u1.poj_user)
      FactoryGirl.create(:poj_submission_wa, problem_id: p1, user: u2.poj_user, submitted_at: t1)
      FactoryGirl.create(:poj_submission_ac, problem_id: p1, user: u2.poj_user, submitted_at: t2)
      FactoryGirl.create(:poj_submission_wa, problem_id: p2, user: u1.poj_user)
      FactoryGirl.create(:poj_submission_ac, problem_id: p3, user: u2.poj_user)
    end

    it 'returns standing' do
      problem_ids = [p1, p2].map(&:to_s)
      h = described_class.standing([u1, u2], problem_ids)
      expect(h).to be_a Hash
      expect(h.keys.sort).to eq [u1.name, u2.name].sort
      h.values.each do |h2|
        expect(h2.keys.sort).to eq problem_ids.sort
      end
      expect(h[u1.name][p1.to_s][:status]).to eq 'AC'
      expect(h[u2.name][p1.to_s][:status]).to eq 'AC'
      expect(h[u1.name][p2.to_s][:status]).to eq 'WA'
      expect(h[u2.name][p2.to_s]).to be_nil
    end
  end

  describe '.solved_users' do
    let(:u1) { FactoryGirl.create(:user) }
    let(:u2) { FactoryGirl.create(:user) }
    let(:u3) { FactoryGirl.create(:user) }
    let(:p1) { 1000 }
    let(:p2) { 2000 }

    before do
      2.times { FactoryGirl.create(:poj_submission_ac, problem_id: p1, user: u1.poj_user) }
      FactoryGirl.create(:poj_submission_wa, problem_id: p1, user: u2.poj_user)
      FactoryGirl.create(:poj_submission_wa, problem_id: p2, user: u1.poj_user)
      FactoryGirl.create(:poj_submission_ac, problem_id: p1, user: u3.poj_user)
    end

    it 'returns users who solve this problem' do
      expect(described_class.solved_users(p1.to_s)).to match_array([u1, u3])
      expect(described_class.solved_users(p2.to_s)).to be_empty
    end
  end

  describe '.recent' do
    let!(:s1) { FactoryGirl.create :poj_submission_ac, submitted_at: 5.weeks.ago }
    let!(:s2) { FactoryGirl.create :poj_submission_ac, submitted_at: 3.weeks.ago }
    let!(:s3) { FactoryGirl.create :poj_submission_ac, submitted_at: 2.weeks.ago }
    it 'returns submissions in 1 month in submitted_at order' do
      subs = described_class.recent
      expect(subs).to eq([s3, s2])
    end
  end
end
