shared_examples 'a site problem page' do
  given(:submission_class) { "#{site.camelize}Submission".constantize }

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

  given(:problem) { FactoryGirl.create(:problem, site: site) }
  given(:user1) { FactoryGirl.create(:user) }
  given(:user2) { FactoryGirl.create(:user) }
  let!(:sub1) { create_ac(problem, user1, 5.days.ago) }
  let!(:sub2) { create_wa(problem, user2, 4.days.ago) }

  scenario ':site/recent shows recent ACs and graph', js: true do
    visit "/#{site}/recent"
    expect(page).to have_content("ACs at #{site.upcase}")
    expect(page).to have_css('#weekly-graph svg')
    expect(page).to have_link(user1.name)
    expect(page).not_to have_link(user2.name)
  end

  scenario ':site/:problem_id creates a new SiteProblem if not exists' do
    expect {
      visit "/#{site}/#{problem.problem_id}0"
    }.to change { SiteProblem.count }.by(1)
  end
end
