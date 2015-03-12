class SessionsController < ApplicationController
  before_action :logged_in, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if @user
      login_user!
      redirect_to cats_url
    else
      flash[:errors] = ['Invalid login']
      render :new
    end
  end

  def destroy
    @session = Session.find_by_session_token(session[:session_token])
    @session.destroy
    session[:session_token] = nil

    redirect_to new_session_url
  end


  def login_user!
    token = Session.generate_session_token
    @session = @user.sessions.new(session_token: token)
    if @session.save
      session[:session_token] = @session.session_token
    else
      flash[:errors] = ["something is really, really wrong"]
    end
  end

  private

  def logged_in
    @session = Session.find_by_session_token(session[:session_token])
    if @session
      redirect_to cats_url
    end
  end
end
