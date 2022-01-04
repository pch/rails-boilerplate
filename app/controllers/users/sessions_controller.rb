class Users::SessionsController < ApplicationController
  skip_before_action :require_confirmed_email
  before_action :disallow_logged_in_user, except: %i[destroy]

  def new
  end

  def create
    @user = User.authenticate_with_email_and_password(params[:email], params[:password])

    if @user
      log_in(@user)
      redirect_to after_log_in_path
    else
      track_activity!(action: "failed_login", metadata: { email: params[:email] })
      @error = t("users.sessions.invalid_credentials")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if params[:id]
      session = Users::Session.find_by_hashid!(params[:id])
      track_activity!(action: "logout", session: session)
      session.revoke!
      redirect_to edit_users_user_path
    else
      log_out
      redirect_to root_url, notice: t("users.sessions.logged_out")
    end
  end
end
