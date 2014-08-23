shared_examples 'a site problems controller' do
  let(:site) { described_class.site }
  let(:submission_class) { described_class.submission_class }

  def create_submission(sym, problem, user, submitted_at)
    params = {}
    params[:problem_id] = problem.is_a?(SiteProblem) ? problem.problem_id : problem
    params[submission_class.user_field] = user.is_a?(User) ? user.user_in(site) : user
    params[submission_class.submitted_at_field] = submitted_at
    FactoryGirl.create(:"#{site}_submission_#{sym}", params)
  end

  def create_ac(problem, user, submitted_at)
    create_submission(:ac, problem, user, submitted_at)
  end

  def create_wa(problem, user, submitted_at)
    create_submission(:wa, problem, user, submitted_at)
  end

  describe '#show' do
    let(:problem1) { FactoryGirl.create(:problem, site: site) }
    let(:problem2) { FactoryGirl.create(:problem, site: site) }
    let(:user1) { user }
    let(:user2) { FactoryGirl.create(:user) }

    let!(:sub1) { create_ac(problem1, user1, 5.days.ago) }
    # Other problems are not displaye
    let!(:sub2) { create_ac(problem2, user1, 4.days.ago) }
    # Non-accepts submissions are alsplayed.
    let!(:sub3) { create_wa(problem1, user2, 3.days.ago) }
    # Non-member submissions are not ayed.
    let!(:sub4) { create_ac(problem1, 'non_member', 2.days.ago) }

    let(:con1) { FactoryGirl.create(:contest) }
    let(:con2) { FactoryGirl.create(:contest) }
    let(:con3) { FactoryGirl.create(:contest) }

    before do
      con1.site_problems << problem1 << problem2
      con2.site_problems << problem1
      con3.site_problems << problem2

      problem1.tags = [tag1, tag2]
      problem1.save!
      problem2.tags = [tag2]
      problem2.save!
    end

    it 'sets submissions of the problem in submission date order' do
      get :show, problem_id: problem1.problem_id
      expect(response).to be_ok
      expect(response).to render_template('site_problems/show')
      expect(assigns(:problem)).to eq(problem1)
      expect(assigns(:submissions)).to eq([sub3, sub1])
      expect(assigns(:solved_users)).to match_array([user1])
      expect(assigns(:used_contests)).to match_array([con1, con2])
      expect(assigns(:tags).map(&:name)).to eq([tag2.name, tag1.name])
    end
  end

  describe '#recent' do
    let(:user1) { user }
    let(:user2) { FactoryGirl.create(:user) }
    let!(:sub1) { create_ac('1000', user1, 2.months.ago) }
    let!(:sub2) { create_ac('1010', user2, 3.weeks.ago) }
    let!(:sub3) { create_wa('1011', user2, 3.days.ago) }
    let!(:sub4) { create_ac('1100', user1, 2.days.ago) }
    let!(:sub5) { create_ac('1101', 'non_member', Time.now) }

    it 'sets recent accepts in submission date order' do
      get :recent
      expect(response).to be_ok
      expect(assigns(:site)).to eq(site)
      expect(assigns(:submissions)).to eq([sub4, sub2])
      expect(response).to render_template('site_problems/recent')
    end
  end

  describe '#edit_tags' do
    let(:problem1) { FactoryGirl.create(:problem, site: site) }
    let(:problem2) { FactoryGirl.create(:problem, site: site) }

    before do
      problem1.tags = [tag1, tag2]
      problem1.save!
      problem2.tags = [tag2]
      problem2.save!
    end

    context 'without sign-in' do
      it 'rejects' do
        get :edit_tags, problem_id: problem1.problem_id
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'with sign-in' do
      before do
        session[:user_id] = user.id
      end

      it 'works' do
        get :edit_tags, problem_id: problem1.problem_id
        expect(response).to be_ok
        expect(assigns(:tags).map(&:name)).to eq([tag2.name, tag1.name])

        get :edit_tags, problem_id: problem2.problem_id
        expect(response).to be_ok
        expect(assigns(:tags).map(&:name)).to eq([tag2.name, tag1.name])
      end
    end
  end

  describe '#update_tags' do
    let(:problem1) { FactoryGirl.create(:problem, site: site) }
    let(:problem2) { FactoryGirl.create(:problem, site: site) }

    context 'without sign-in' do
      it 'rejects' do
        post :update_tags, problem_id: problem1.problem_id, tags: [tag1.name, tag2.name]
        expect(response).to redirect_to(new_session_path)
      end
    end

    context 'with sign-in' do
      before do
        session[:user_id] = user.id
      end

      it 'works' do
        extend SiteProblemsHelper
        post :update_tags, problem_id: problem1.problem_id, tags: [tag1.name, tag2.name]
        expect(response).to redirect_to(problem_path(problem1))
        problem1.reload
        expect(problem1.tags.map(&:name)).to match_array([tag2.name, tag1.name])
      end
    end
  end
end
