require 'spec_helper'

RSpec.describe Contest do
  let(:user) { FactoryGirl.create(:user) }

  describe '#save' do
    it 'saves with name' do
      c = described_class.new(name: 'name', owner_id: user.id)
      expect { c.save! }.to change { Activity.count }.by(1)
      activity = Activity.recent(1).first
      expect(activity.user).to eq(user)
      expect(activity).to be_contest_create
      expect(activity.target).to eq(c)
    end

    it 'requires name' do
      c = described_class.new(owner_id: user.id)
      expect(c.save).to be(false)
    end

    it 'requires owner' do
      c = described_class.new(name: 'name')
      expect(c.save).to be(false)
    end

    it 'rejects if name contains .' do
      c = described_class.new(name: '.', owner_id: user.id)
      expect(c.save).to be(false)
      expect(c.errors[:name]).not_to be_empty
    end

    it 'rejects if name contains /' do
      c = described_class.new(name: '/', owner_id: user.id)
      expect(c.save).to be(false)
      expect(c.errors[:name]).not_to be_empty
    end

    it 'rejects if name is "new"' do
      c = described_class.new(name: 'new', owner_id: user.id)
      expect(c.save).to be(false)
      expect(c.errors[:name]).not_to be_empty
    end
  end
end
