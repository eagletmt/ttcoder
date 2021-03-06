require 'spec_helper'

RSpec.describe 'Site problem', type: :feature do
  describe 'POJ' do
    let(:site) { 'poj' }
    it_behaves_like 'a site problem page'
  end

  describe 'AOJ' do
    let(:site) { 'aoj' }
    it_behaves_like 'a site problem page'
  end

  describe 'Codeforces' do
    let(:site) { 'codeforces' }
    it_behaves_like 'a site problem page'
  end
end
