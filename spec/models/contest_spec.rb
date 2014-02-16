require 'spec_helper'

describe Contest do
  describe '#save' do
    it 'saves with name' do
      c = described_class.new name: 'name'
      expect(c.save).to be(true)
    end

    it 'requires name' do
      c = described_class.new
      expect(c.save).to be(false)
    end

    it 'rejects if name contains .' do
      c = described_class.new name: '.'
      expect(c.save).to be(false)
      expect(c.errors[:name]).not_to be_empty
    end

    it 'rejects if name contains /' do
      c = described_class.new name: '/'
      expect(c.save).to be(false)
      expect(c.errors[:name]).not_to be_empty
    end

    it 'rejects if name is "new"' do
      c = described_class.new name: 'new'
      expect(c.save).to be(false)
      expect(c.errors[:name]).not_to be_empty
    end
  end
end
