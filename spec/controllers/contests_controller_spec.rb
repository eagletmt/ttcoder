require 'spec_helper'

RSpec.describe ContestsController, type: :controller do
  let(:users) { 2.times.map { FactoryGirl.create :user } }
  let(:u1) { users[0] }
  let(:u2) { users[1] }
  let(:p1) { FactoryGirl.create :poj_problem }
  let(:p2) { FactoryGirl.create :aoj_problem }
  let(:p3) { FactoryGirl.create :poj_problem }
  let(:problems) { [p1, p2, p3] }
  let(:contest) { FactoryGirl.create(:contest, users: users) }

  before do
    problems.each do |problem|
      contest.site_problems << problem
    end

    FactoryGirl.create(:poj_submission_ac, user: u1.poj_user, problem_id: p1.problem_id)
    FactoryGirl.create(:poj_submission_ac, user: u1.poj_user.swapcase, problem_id: p3.problem_id)
    FactoryGirl.create(:poj_submission_wa, user: u2.poj_user, problem_id: p1.problem_id)

    session[:user_id] = u1.id
  end

  describe '#index' do
    it 'assigns to @contests in ascending order of created_at' do
      FactoryGirl.create :contest, created_at: contest.created_at - 1.day
      get :index
      contests = assigns :contests
      expect(contests.size).to eq(2)
      expect(contests[0].created_at).to be < contests[1].created_at
    end
  end

  describe '#create' do
    context 'with empty name' do
      let(:contest_name) { '' }
      let(:contest_message) { 'Something went wrong' }
      let(:contest_params) { { name: contest_name, message: contest_message} }

      it 'rejects' do
        post :create, contest: contest_params
        expect(response).to be_ok
        expect(response).to render_template(:new)
        contest = assigns(:contest)
        expect(contest.errors[:name]).not_to be_empty
        expect(contest.message).to eq(contest.message)
      end
    end
  end

  describe '#show' do
    it 'assigns @standing' do
      get :show, id: contest.name
      expect(response).to be_ok
      standing = assigns :standing

      expect(standing).to be_a Hash
      expect(standing.keys.sort).to eq users.map(&:name).sort
      descs = problems.map(&:description).sort
      standing.values.each do |h|
        expect(h.keys.sort).to eq descs
      end

      expect(standing[u1.name][p1.description][:status]).to eq 'AC'
      expect(standing[u2.name][p1.description][:status]).to eq 'WA'
      expect(standing[u1.name][p3.description][:status]).to eq 'AC'
      expect(standing[u2.name][p3.description]).to be_nil
    end

    it 'assigns @scores' do
      get :show, id: contest.name
      expect(response).to be_ok
      scores = assigns :scores
      expect(scores).to be_a Hash
      expect(scores.keys.sort).to eq users.map(&:name).sort
      expect(scores[u1.name]).to eq 720.0
      expect(scores[u2.name]).to eq 0.0
    end

    context 'with empty users' do
      before do
        contest.users.each do |user|
          contest.users.destroy(user)
        end
      end

      it 'assigns @scores with empty hash' do
        get :show, id: contest.name
        expect(response).to be_ok
        scores = assigns :scores
        expect(scores).to be_a Hash
        expect(scores).to be_empty
      end
    end

    context 'with empty problems' do
      before do
        contest.site_problems.clear
      end

      it 'assigns @scores with hash filled with 0' do
        get :show, id: contest.name
        expect(response).to be_ok
        scores = assigns :scores
        expect(scores).to be_a Hash
        expect(scores.keys.sort).to eq users.map(&:name).sort
        expect(scores.values).to be_all { |x| x == 0.0 }
      end
    end
  end

  describe '#edit' do
    it 'works' do
      get :edit, id: contest.name
      expect(response).to be_ok
    end

    it 'assigns @last_type' do
      get :edit, id: contest.name
      expect(assigns(:last_type)).to eq 'poj'
    end
  end

  describe '#add_problem' do
    let(:problem_params) { { site: 'poj', problem_id: 100 } }

    it 'adds new problem at the last' do
      expect do
        post :add_problem, id: contest.name, problem: problem_params
        contest.reload
      end.to change { contest.site_problems.count }.by 1
      expect(response).to redirect_to edit_contest_path(contest)
      last = contest.site_problems.last
      expect(last.site).to eq problem_params[:site]
      expect(last.problem_id).to eq problem_params[:problem_id].to_s
    end

    context 'with duplication' do
      before do
        post :add_problem, id: contest.name, problem: problem_params
        contest.reload
      end

      it 'rejects' do
        expect {
          post :add_problem, id: contest.name, problem: problem_params
          contest.reload
        }.not_to change { contest.site_problems.count }
        expect(response).to redirect_to(edit_contest_path(contest))
        expect(flash.alert).to include('Invalid problem')
      end
    end
  end

  describe '#join' do
    let(:new_user) { FactoryGirl.create(:user) }

    context 'with signed-in' do
      before do
        session[:user_id] = new_user.id
      end

      it 'works' do
        expect { post :join, id: contest.name }.to change { contest.reload.users.exists?(new_user.id) }.from(false).to(true)
        expect(response).to redirect_to(contest)
        expect(flash[:notice]).not_to be_nil
        expect(flash[:alert]).to be_nil
      end

      context 'but when already joined' do
        before do
          contest.users << new_user
        end

        it 'rejects' do
          expect { post :join, id: contest.name }.not_to change { contest.reload.users.exists?(new_user.id) }
          expect(response).to redirect_to(contest)
          expect(flash[:notice]).to be_nil
          expect(flash[:alert]).not_to be_nil
        end
      end
    end
  end
end
