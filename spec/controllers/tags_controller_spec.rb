require 'spec_helper'

RSpec.describe TagsController, type: :controller do
  let(:problem1) { FactoryGirl.create(:poj_problem) }
  let(:problem2) { FactoryGirl.create(:aoj_problem) }
  let(:problem3) { FactoryGirl.create(:poj_problem) }
  let!(:tag1) { FactoryGirl.create(:tag, name: 'abc') }
  let!(:tag2) { FactoryGirl.create(:tag, name: 'aba') }
  let!(:tag3) { FactoryGirl.create(:tag, name: 'z') }

  before do
    problem1.tags = [tag1, tag2]
    problem1.save!
    problem2.tags = [tag2]
    problem2.save!
    problem3.tags = [tag1]
    problem3.save!
  end

  describe '#index' do
    it 'lists tags of problems in alphabetical order' do
      get :index
      expect(response).to be_ok
      tags = assigns(:tags)
      expect(tags.size).to eq(3)
      expect(tags[0].name).to eq(tag2.name)
      expect(tags[1].name).to eq(tag1.name)
    end
  end

  describe '#show' do
    it 'shows problems' do
      get :show, params: { id: tag1.name }
      expect(response).to be_ok
      expect(assigns(:problems)).to match_array([problem1, problem3])

      get :show, params: { id: tag2.name }
      expect(response).to be_ok
      expect(assigns(:problems)).to match_array([problem1, problem2])

      get :show, params: { id: tag3.name }
      expect(response).to be_ok
      expect(assigns(:problems)).to be_empty
    end
  end

  describe '#create' do
    let(:tag_params) { { tag: { name: 'new-tag' } } }

    context 'without sign-in' do
      it 'rejects' do
        expect {
          post :create, params: tag_params
          expect(response).to redirect_to(new_session_path)
        }.not_to change { Tag.count }
      end
    end

    context 'with sign-in' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'creates a new tag' do
        session[:return_to] = poj_path('2000')
        expect {
          post :create, params: tag_params
          expect(response).to redirect_to(poj_path('2000'))
        }.to change { Tag.count }.by(1)

        expect(Tag.find_by!(name: tag_params[:tag][:name]).owner).to eq(user)
      end

      it 'rejects invalid tag name' do
        tag_params[:tag][:name] = 'Invalid tag with spaces'
        expect {
          post :create, params: tag_params
        }.not_to change { Tag.count }
      end
    end
  end
end
