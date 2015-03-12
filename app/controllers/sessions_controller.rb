class SessionsController < ApplicationController
  before_action :ensure_not_logged_in, only: [:new, :create]
  before_action :ensure_logged_in, only: [:index]

  def index
    @sessions = Session.where(user_id: current_user.id)
    render :index
  end

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
    @session = Session.find(params[:id])
    @session.destroy

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

  def ensure_not_logged_in
    @session = Session.find_by_session_token(session[:session_token])
    if @session
      redirect_to cats_url
    end
  end

  def ensure_logged_in
    @session = Session.find_by_session_token(session[:session_token])
    unless @session
      redirect_to new_session_url
    end
  end
end
