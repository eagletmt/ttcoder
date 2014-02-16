module AojSubmissionDecorator
  def submission_link
    "http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=#{run_id}"
  end
end
