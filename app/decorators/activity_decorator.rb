module ActivityDecorator
  def description
    send("#{kind}_description").html_safe
  end

  def submission_create_description
    problem = SiteProblem.new(site: target.class.site, problem_id: target.problem_id)
    submission = ActiveDecorator::Decorator.instance.decorate(target)
    "#{link_to_user} submitted to #{link_to(problem.description, problem_path(problem))} and got #{link_to(target.abbrev_status, submission.submission_link)}"
  end

  def contest_create_description
    "#{link_to_user} created contest #{link_to(target.name, target)}"
  end

  def contest_update_description
    "#{link_to_user} updated contest #{link_to(target.name, target)}"
  end

  def tag_create_description
    "#{link_to_user} created tag #{link_to(target.name, target)}"
  end

  def tags_update_description
    tag_links = Tag.where(id: parameters).map { |tag| link_to(tag.name, tag) }
    "#{link_to_user} updated tags of #{link_to(target.description, problem_path(target))} to #{tag_links.join(', ')}"
  end

  def contest_join_description
    "#{link_to_user} joined to contest #{link_to(target.name, target)}"
  end

  def contest_leave_description
    "#{link_to_user} left contest #{link_to(target.name, target)}"
  end

  def link_to_user
    link_to(user.name, user)
  end
end
