module UserDecorator
  def poj_link
    "http://poj.org/userstatus?user_id=#{poj_user}"
  end

  def aoj_link
    "http://judge.u-aizu.ac.jp/onlinejudge/user.jsp?id=#{aoj_user}"
  end
end
