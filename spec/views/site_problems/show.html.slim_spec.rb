require 'spec_helper'

RSpec.describe 'site_problems/show', type: :view do
  context 'with poj' do
    let(:site) { 'poj' }
    it_behaves_like 'a site problems show'
  end

  context 'with aoj' do
    let(:site) { 'aoj' }
    it_behaves_like 'a site problems show'
  end
end
