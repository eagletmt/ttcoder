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
        redirect_to associate_user_path
      end
    else
      redirect_to new_session_path
    end
  end

  def new_associate
    if flash[:auth]
      @new_username = flash[:auth][:info][:nickname]
      flash.keep(:auth)
      render :associate
    else
      redirect_to new_session_path
    end
  end

  def associate
    if flash[:auth]
      if params[:commit] == 'Associate'
        prev_user = User.find_by(name: params[:prev_user])
        if prev_user
          if prev_user.twitter_user
            @already_taken = prev_user
          else
            user = User.find_or_new_from_omniauth(flash[:auth])
            prev_user.twitter_user = user.twitter_user
            prev_user.save!
            login! prev_user
          end
        else
          flash.keep(:auth)
          @prev_not_found = params[:prev_user]
        end
      else
        user = User.find_or_new_from_omniauth(flash[:auth])
        user.save!
        login! user
      end
    else
      redirect_to new_session_path
    end
  end

  def back
    redirect_to(session[:return_to] || root_path)
    session[:return_to] = nil
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
end
