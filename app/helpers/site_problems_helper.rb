module SiteProblemsHelper
  def problem_path(problem)
    send("#{problem.site}_path", problem.problem_id)
  end

  def update_problem_tags_path(problem)
    send("update_#{problem.site}_tags_path", problem.problem_id)
  end

  def edit_problem_tags_path(problem)
    send("edit_#{problem.site}_tags_path", problem.problem_id)
  end
end
