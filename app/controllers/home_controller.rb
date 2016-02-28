class HomeController < ApplicationController
  def index
    @users = User.all.order_by_name
    @poj_usermap = PojSubmission.make_usermap(@users)
    @aoj_usermap = AojSubmission.make_usermap(@users)
    @codeforces_usermap = CodeforcesSubmission.make_usermap(@users)
    count = 10
    @poj_submissions = PojSubmission.user(@poj_usermap.keys).accepts.order_by_submission.limit(count)
    @aoj_submissions = AojSubmission.user(@aoj_usermap.keys).accepts.order_by_submission.limit(count)
    @codeforces_submissions = CodeforcesSubmission.user(@codeforces_usermap.keys).accepts.order_by_submission.limit(count)
  end
end
