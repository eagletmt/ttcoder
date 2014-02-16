require 'spec_helper'

feature 'Site problem' do
  describe 'POJ' do
    let(:site) { 'poj' }
    it_behaves_like 'a site problem page'
  end

  describe 'AOJ' do
    let(:site) { 'aoj' }
    it_behaves_like 'a site problem page'
  end
end
