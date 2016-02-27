require 'spec_helper'

RSpec.describe 'site controller routing', type: :routing do
  describe '/poj' do
    it 'routes integer problem_id' do
      expect(get: '/poj/0123').to route_to(controller: 'poj', action: 'show', problem_id: '0123')
      expect(get: '/poj/0123/edit_tags').to route_to(controller: 'poj', action: 'edit_tags', problem_id: '0123')
      expect(post: '/poj/0123/update_tags').to route_to(controller: 'poj', action: 'update_tags', problem_id: '0123')
    end

    it 'does not route non-integer problem_id' do
      expect(get: '/poj/new').not_to be_routable
      expect(get: '/poj/new/edit_tags').not_to be_routable
      expect(post: '/poj/new/update_tags').not_to be_routable
    end
  end

  describe '/aoj' do
    it 'routes integer problem_id' do
      expect(get: '/aoj/0123').to route_to(controller: 'aoj', action: 'show', problem_id: '0123')
      expect(get: '/aoj/0123/edit_tags').to route_to(controller: 'aoj', action: 'edit_tags', problem_id: '0123')
      expect(post: '/aoj/0123/update_tags').to route_to(controller: 'aoj', action: 'update_tags', problem_id: '0123')
    end

    it 'does not route non-integer problem_id' do
      expect(get: '/aoj/new').not_to be_routable
      expect(get: '/aoj/new/edit_tags').not_to be_routable
      expect(post: '/aoj/new/update_tags').not_to be_routable
    end
  end

  describe '/codeforces' do
    it 'routes /\d{3}[A-Z]\d?/ problem_id' do
      expect(get: '/codeforces/123A').to route_to(controller: 'codeforces', action: 'show', problem_id: '123A')
      expect(get: '/codeforces/123A1').to route_to(controller: 'codeforces', action: 'show', problem_id: '123A1')
      expect(get: '/codeforces/123A/edit_tags').to route_to(controller: 'codeforces', action: 'edit_tags', problem_id: '123A')
      expect(post: '/codeforces/123A/update_tags').to route_to(controller: 'codeforces', action: 'update_tags', problem_id: '123A')
    end

    it 'does not route not /\d{3}[A-Z]\d?/ problem_id' do
      expect(get: '/codeforces/new').not_to be_routable
      expect(get: '/codeforces/new/edit_tags').not_to be_routable
      expect(post: '/codeforces/new/update_tags').not_to be_routable
    end    
  end
end
