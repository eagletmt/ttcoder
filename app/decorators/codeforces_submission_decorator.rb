module CodeforcesSubmissionDecorator
  def submission_link
    "http://codeforces.com/contest/#{problem_id.split(/[A-Z]/)[0]}/submission/#{id}"
  end
end
