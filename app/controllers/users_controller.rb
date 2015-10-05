class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @users =
      if params[:q].present?
        @users = User.order('lower(name)').where('lower(name) LIKE ?', "#{params[:q].downcase}%")
      else
        @users = User.order('lower(name)').all
      end
  end

  ACTIVITY_COUNT = 50
  def show
    @poj_tried_count = StandingCache.where(user: @user.poj_user.downcase, problem_type: :poj).count
    @aoj_tried_count = StandingCache.where(user: @user.aoj_user.downcase, problem_type: :aoj).count
    @poj_accept_count = StandingCache.where(user: @user.poj_user.downcase, problem_type: :poj).where(status: 'Accepted').count
    @aoj_accept_count = StandingCache.where(user: @user.aoj_user.downcase, problem_type: :aoj).where(status: 'Accepted').count

    @poj_tried_but_failed = StandingCache.where(user: @user.poj_user.downcase, problem_type: :poj).where.not(status: 'Accepted')
    @aoj_tried_but_failed = StandingCache.where(user: @user.aoj_user.downcase, problem_type: :aoj).where.not(status: 'Accepted')

    @poj_tried_but_failed_count = @poj_tried_but_failed.count
    @aoj_tried_but_failed_count = @aoj_tried_but_failed.count

    @activities = Activity.recent(ACTIVITY_COUNT).where(user: @user)
  end

  def edit
    @user = @current_user
  end

  def update
    if @current_user.update(user_params)
      redirect_to @current_user, notice: 'User was successfully updated.'
    else
      @current_user.name = @current_user.name_was
      @user = @current_user
      render action: 'edit'
    end
  end

  private

  def set_user
    @user = User.find_by! name: params[:id]
  end

  def user_params
    params.require(:user).permit(
      :name, :poj_user, :aoj_user,
      twitter_user_attributes: [:id, :public],
    )
  end
end
