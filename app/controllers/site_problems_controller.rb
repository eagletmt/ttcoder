class SiteProblemsController < ApplicationController
  before_action :set_usermap, only: [:recent, :weekly, :show]
  before_action :authenticate_user!, only: [:edit_tags, :update_tags]

  module ClassMethods
    attr_accessor :site

    def inherited(child)
      guess_site_from_class_name(child)
    end

    def guess_site_from_class_name(child)
      if m = child.name.match(/\A(.+)Controller\z/)
        child.site = m[1].underscore
      end
    end

    def submission_class
      SiteProblem.submission_class_for(site)
    end
  end
  extend ClassMethods

  def recent
    @site = site
    @submissions = submission_class.user(@usermap.keys).accepts.recent.limit(100)
  end

  def weekly
    date = 6.days.ago(Date.today)
    @dates = []
    @weekly = Hash.new { |h, k| h[k] = 7.times.map { 0 } }
    7.times do |i|
      @dates << date
      d = date.next_day
      submission_class.user(@usermap.keys).accepts.between(date, d)
      .group_by_user.distinct.count(:problem_id).each do |user_id, count|
        @weekly[@usermap[user_id.downcase].name][i] = count
      end
      date = d
    end
  end

  ACTIVITY_COUNT = 20
  def show
    @problem = SiteProblem.find_or_create_by(site: site, problem_id: params[:problem_id])
    @used_contests = @problem.contests
    @count = 100
    @submissions = submission_class.user(@usermap.keys).where(problem_id: @problem.problem_id).order_by_submission.limit(@count)
    @solved_users = SiteProblem.solved_users(site, @problem.problem_id)
    @tags = @problem.tags.order(:name)
    @activities = Activity.recent(ACTIVITY_COUNT).where(target: @problem)
  end

  def edit_tags
    @problem = SiteProblem.find_or_create_by(site: site, problem_id: params[:problem_id])
    @tags =Tag.all.order(:name)
    @tag = Tag.new
    session[:return_to] = request.fullpath
  end

  def update_tags
    site_problem = SiteProblem.find_or_create_by(site: site, problem_id: params[:problem_id])
    site_problem.tags = params[:tags].map { |tag| Tag.find_by!(name: tag) }
    site_problem.save!
    Activity.create(user: @current_user, target: site_problem, kind: :tags_update, parameters: site_problem.tags.pluck(:id))
    redirect_to send(:"#{site}_path", params[:problem_id])
    session[:return_to] = nil
  end

  def set_usermap
    @usermap = submission_class.make_usermap(User.all)
  end

  def submission_class
    self.class.submission_class
  end

  def site
    self.class.site
  end
end
