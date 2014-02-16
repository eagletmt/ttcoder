module ContestsHelper
  def problem_link(problem)
    send "#{problem.site}_link", problem.problem_id
  end

  def poj_link(problem_id)
    "http://poj.org/problem?id=#{problem_id}"
  end

  def aoj_link(problem_id)
    "http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=#{problem_id}"
  end

  def check_old(contest, submitted_at)
    if submitted_at.try { |time| time < contest.created_at }
      'old'
    end
  end
end
