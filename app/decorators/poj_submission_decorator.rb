module PojSubmissionDecorator
  def submission_link
    "http://poj.org/status?problem_id=#{problem_id}&user_id=#{user}&top=#{id + 1}"
  end
end
