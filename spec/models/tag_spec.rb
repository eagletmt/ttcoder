require 'spec_helper'

RSpec.describe Tag do
  describe '#save' do
    let(:tag) { FactoryGirl.build(:tag) }

    it 'saves' do
      expect(tag.save).to eq(true)
    end

    it 'creates activity' do
      expect { tag.save! }.to change { Activity.count }.by(1)
      activity = Activity.recent(1).first
      expect(activity).to be_tag_create
      expect(activity.user).to eq(tag.owner)
      expect(activity.target).to eq(tag)
    end
  end
end
