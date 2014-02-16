require 'spec_helper'

describe 'site_problems/show' do
  context 'with poj' do
    let(:site) { 'poj' }
    it_behaves_like 'a site problems show'
  end

  context 'with aoj' do
    let(:site) { 'aoj' }
    it_behaves_like 'a site problems show'
  end
end
