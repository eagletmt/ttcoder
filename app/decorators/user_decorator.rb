module UserDecorator
  def poj_link
    "http://poj.org/userstatus?user_id=#{poj_user}"
  end

  def aoj_link
    "http://judge.u-aizu.ac.jp/onlinejudge/user.jsp?id=#{aoj_user}"
  end

  def create_button_text(from_contest)
    if new_record?
      if from_contest
        "Create and register to contest #{from_contest}"
      else
        'Create'
      end
    else
      'Update'
    end
  end
end
