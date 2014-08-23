class TagsController < ApplicationController
  before_action :set_tag, only: [:show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @tags = Tag.order(:name)
  end

  def create
    @tag = Tag.new(tag_params.merge(owner: @current_user))

    if @tag.save
      redirect_to(session[:return_to] || root_path, notice: 'Tag was successfully updated.')
    else
      redirect_to(session[:return_to] || root_path, alert: 'Invalid tag name. tag name must be [a-z-]+.')
    end
  end

  def show
    @problems = @tag.site_problems.sort_by(&:description)
  end

  private

  def set_tag
    @tag = Tag.find_by!(name: params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
