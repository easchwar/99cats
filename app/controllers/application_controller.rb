class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :current_session

  def current_user
    session = current_session
    if session
      session.user
    else
      nil
    end
  end

  def current_session
    @session ||= Session.find_by_session_token(session[:session_token])
  end
end
