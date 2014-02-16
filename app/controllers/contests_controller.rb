class ContestsController < ApplicationController
  before_action :set_contest, only: [:show, :edit, :update, :destroy, :join, :leave, :add_problem, :remove_problem, :up_problem, :down_problem]
  before_action :keep_last_type, only: [:edit, :remove_problem, :up_problem, :down_problem]

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @contests = Contest.all
  end

  def show
    @users = @contest.users
    @problems = @contest.site_problems.to_a
    @standing = Hash.new { |h, k| h[k] = {} }
    @problems.group_by(&:site).each do |site, problems|
      SiteProblem.standing_for(site, @users, problems).each do |user_id, h|
        h.each do |problem_id, result|
          desc = SiteProblem.description(site, problem_id)
          @standing[user_id][desc] = result
        end
      end
    end
    @scores = calculate_scores @users, @problems, @standing
  end

  def new
    @contest = Contest.new
  end

  def edit
    @last_type = flash[:last_type] || 'poj'
  end

  def create
    @contest = Contest.new(contest_params.merge(owner: @current_user))

    if @contest.save
      redirect_to @contest, notice: 'Contest was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @contest.update(contest_params)
      redirect_to @contest, notice: 'Contest was successfully updated.'
    else
      @contest.name = @contest.name_was
      render action: 'edit'
    end
  end

  def add_problem
    @problem = SiteProblem.find_or_create_by(problem_params)
    begin
      @contest.site_problems << @problem
      redirect_to edit_contest_path(@contest), flash: { last_type: @problem.site }
    rescue ActiveRecord::RecordInvalid
      redirect_to edit_contest_path(@contest), alert: 'Invalid problem'
    end
  end

  def remove_problem
    @contest.site_problems.delete(params[:problem_id])
    redirect_to edit_contest_path(@contest)
  end

  def join
    @contest.users << @current_user
    redirect_to contest_path(@contest), notice: "Joined to #{@contest.name}"
  rescue ActiveRecord::RecordInvalid
    redirect_to contest_path(@contest), alert: "You have already joined!"
  end

  def leave
    if @contest.users.delete(@current_user)
      redirect_to contest_path(@contest), notice: "Left from #{@contest.name}"
    else
      redirect_to contest_path(@contest), alert: "You haven't joined!"
    end
  end

  def up_problem
    @contest.contests_site_problems.find_by!(site_problem_id: params[:problem_id]).move_higher
    redirect_to edit_contest_path(@contest)
  end

  def down_problem
    @contest.contests_site_problems.find_by!(site_problem_id: params[:problem_id]).move_lower
    redirect_to edit_contest_path(@contest)
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_contest
      @contest = Contest.find_by! name: params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contest_params
      params.require(:contest).permit(:name, :message)
    end

    def problem_params
      params.require(:problem).permit(:site, :problem_id)
    end

    def user_params
      params.require(:user).permit(:name)
    end

    def keep_last_type
      flash.keep :last_type
    end

    def calculate_scores(users, problems, standing)
      count = {}
      problems.each do |problem|
        count[problem.description] = 0
      end
      standing.each do |user, h|
        h.each do |problem, result|
          if result.try(:fetch, :status) == 'AC'
            count[problem] += 1
          end
        end
      end

      scores = {}
      users.each do |user|
        scores[user.name] = 0.0
        standing[user.name].each do |problem, result|
          scores[user.name] += 360.0 / count[problem] if result.try(:fetch, :status) == 'AC'
        end
      end
      scores
    end
end
