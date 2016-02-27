class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env['omniauth.auth']
    if auth
      user = User.find_or_new_from_omniauth(auth)
      if user.persisted?
        login! user
      else
        flash[:auth] = auth
        redirect_to new_user_path
      end
    else
      redirect_to new_session_path
    end
  end

  def new_user
    if flash[:auth]
      @user = User.find_or_new_from_omniauth(flash[:auth])
      flash.keep(:auth)
    else
      redirect_to new_session_path
    end
  end

  def create_user
    if flash[:auth]
      @user = User.find_or_new_from_omniauth(flash[:auth], user_params)
      if @user.save
        login! @user
      else
        flash.keep(:auth)
        render :new_user
      end
    else
      redirect_to new_session_path
    end
  end

  def destroy
    if @current_user
      session[:user_id] = nil
    end
    redirect_to root_path
  end

  private

  def login!(user)
    session[:user_id] = user.id
    back
  end

  def back
    redirect_to(session[:return_to] || root_path)
    session[:return_to] = nil
  end

  def user_params
    params.require(:user).permit(:name, :poj_user, :aoj_user, :codeforces_user)
  end
end
