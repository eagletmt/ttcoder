require 'spec_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    let(:user) { FactoryGirl.create(:user) }
    let(:problem1) { '1000' }
    let(:problem2) { '2000' }
    let(:problem3) { '3000' }

    before do
      FactoryGirl.create(:poj_submission_ac, user: user.poj_user, problem_id: problem1)
      FactoryGirl.create(:poj_submission_wa, user: user.poj_user, problem_id: problem1)
      FactoryGirl.create(:poj_submission_wa, user: user.poj_user, problem_id: problem2)
      FactoryGirl.create(:poj_submission_wa, user: user.poj_user, problem_id: problem3)
      FactoryGirl.create(:poj_submission_wa, user: user.poj_user, problem_id: problem3)
      FactoryGirl.create(:poj_submission_ac, problem_id: problem3)
    end

    it 'works' do
      get :show, id: user.name
      expect(response).to be_ok
      expect(assigns(:poj_tried_count)).to eq(3)
      expect(assigns(:poj_accept_count)).to eq(1)
      expect(assigns(:poj_tried_but_failed_count)).to eq(2)
      expect(assigns(:aoj_tried_count)).to eq(0)
      expect(assigns(:aoj_accept_count)).to eq(0)
      expect(assigns(:aoj_tried_but_failed_count)).to eq(0)
      expect(assigns(:codeforces_tried_count)).to eq(0)
      expect(assigns(:codeforces_accept_count)).to eq(0)
      expect(assigns(:codeforces_tried_but_failed_count)).to eq(0)
    end
  end

  describe '#edit' do
    context 'with signed-in' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'works' do
        get :edit
        expect(response).to be_ok
        expect(assigns(:user).id).to eq(user.id)
      end
    end

    context 'without signed-in' do
      it 'redirects to login' do
        get :edit
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
