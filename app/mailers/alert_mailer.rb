class AlertMailer < ActionMailer::Base
  email = Rails.application.secrets.smtp['user_name']
  default to: email, from: email, charset: 'utf-8'

  def controller_exception(exception)
    @class_name = exception.class.name
    @message = exception.message
    @backtrace = Rails.backtrace_cleaner.clean(exception.backtrace)
    mail(subject: "[ALERT][ttc.wanko.cc] Controller Exception")
  end

  def crawler_error(klass, exception)
    @crawler_name = klass.name
    @class_name = exception.class.name
    @message = exception.message
    @backtrace = Rails.backtrace_cleaner.clean(exception.backtrace)
    mail(subject: '[ALERT][ttc.wanko.cc] Crawler Exception')
  end
end
