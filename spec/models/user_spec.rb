require 'spec_helper'

RSpec.describe User, type: :model do
  describe '#save' do
    it 'saves' do
      u = described_class.new name: 'name', poj_user: 'poj', aoj_user: 'aoj'
      expect(u.save).to be(true)
      expect(u.poj_user).to eq 'poj'
      expect(u.aoj_user).to eq 'aoj'
    end

    it 'requires name' do
      u = described_class.new poj_user: 'poj', aoj_user: 'aoj'
      expect(u.save).to be(false)
    end

    it 'rejects empty name' do
      u = described_class.new name: ''
      expect(u.save).to be(false)
    end

    it 'automatically set poj_user to name' do
      u = described_class.new name: 'name'
      expect(u.save).to be(true)
      expect(u.poj_user).to eq 'name'
    end

    it 'automatically set aoj_user to name' do
      u = described_class.new name: 'name'
      expect(u.save).to be(true)
      expect(u.aoj_user).to eq 'name'
    end

    it 'requires poj_user is unique' do
      u1 = described_class.new name: 'name', poj_user: 'poj'
      u1.save!
      u2 = described_class.new name: 'poj'
      expect(u2.save).to be(false)
      expect(u2.errors[:name]).to be_empty
      expect(u2.errors[:poj_user]).not_to be_empty
      expect(u2.errors[:aoj_user]).to be_empty
    end

    it 'requires aoj_user is unique' do
      u1 = described_class.new name: 'name', aoj_user: 'aoj'
      u1.save!
      u2 = described_class.new name: 'aoj'
      expect(u2.save).to be(false)
      expect(u2.errors[:name]).to be_empty
      expect(u2.errors[:poj_user]).to be_empty
      expect(u2.errors[:aoj_user]).not_to be_empty
    end

    it 'rejects if name contains .' do
      u = described_class.new name: '.'
      expect(u.save).to be(false)
      expect(u.errors[:name]).not_to be_empty
    end

    it 'rejects if name contains /' do
      u = described_class.new name: '.'
      expect(u.save).to be(false)
      expect(u.errors[:name]).not_to be_empty
    end

    it 'rejects if name is "new"' do
      u = described_class.new name: 'new'
      expect(u.save).to be(false)
      expect(u.errors[:name]).not_to be_empty
    end
  end
end
