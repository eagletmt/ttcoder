shared_examples 'a site problems show' do
  before do
    assign :problem, stub_model(SiteProblem, site: site, problem_id: '1234')
    assign :count, 100
    assign :submissions, []
    assign :used_contests, []
    assign :solved_users, []
    assign :tags, []
    assign :activities, []
  end

  context 'with contest' do
    it 'renders Used in' do
      contest = stub_model Contest, name: 'Virtual Arena'
      assign :used_contests, [contest]
      render
      expect(rendered).to have_content('Used in')
      expect(rendered).to have_selector('a', href: contest_path(contest))
    end
  end

  context 'without contest' do
    it "doesn't render Used in" do
      render
      expect(rendered).not_to have_content('Used in')
    end
  end

  context 'with solved users' do
    it 'renders Solved by' do
      user = stub_model User, name: 'Stern'
      assign :solved_users, [user]
      render
      expect(rendered).to have_content('Solved by')
      expect(rendered).to have_selector('a', href: user_path(user))
    end
  end

  context 'without solved users' do
    it "doesn't render Solved by" do
      render
      expect(rendered).not_to have_content('Solved by')
    end
  end
end
