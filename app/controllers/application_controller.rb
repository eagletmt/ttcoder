class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :fluent_logger
  def fluent_logger
    r = yield
    Fluent::Logger.post('access', {
      remote_ip: request.remote_ip,
      method: request.method,
      path: request.fullpath,
      user_agent: request.user_agent,
      controller: params[:controller],
      action: params[:action],
      user_id: session[:user_id],
      status: response.status,
    })
    r
  rescue Exception => e
    Fluent::Logger.post('controller_exception', {
      class: e.class.name,
      message: e.message,
      backtrace: Rails.backtrace_cleaner.clean(e.backtrace),
    })
    unless e.is_a?(ActiveRecord::RecordNotFound)
      AlertMailer.controller_exception(e).deliver
    end
    raise e
  end

  before_action :set_leftbar_contests
  def set_leftbar_contests
    @leftbar_contests = Contest.all.limit(30)
  end

  before_action :set_current_user
  def set_current_user
    @current_user = session[:user_id].try { |user_id| User.find_by(id: user_id) }
  end

  def authenticate_user!
    unless @current_user
      session[:return_to] = request.fullpath
      redirect_to new_session_path, alert: 'Login is required'
    end
  end
end
