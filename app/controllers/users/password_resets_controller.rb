class Users::PasswordResetsController < ApplicationController
  before_action :ensure_valid_token, only: %i[edit update]

  def new
  end

  def create
    @user = User.find_by_normalized_email(params[:email])
    if @user
      track_activity!(action: "password_reset_requested", user: @user)
      UserMailer.with(user: @user).forgot_password.deliver_later
    else
      track_activity!(action: "password_reset_requested", user: User.guest_user, metadata: { email: params[:email] })
    end

    redirect_to new_users_password_reset_path(sent: true)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      activity = track_activity!(action: "password_reset", user: @user)
      UserMailer.with(user: @user, activity: activity).password_changed.deliver_later

      redirect_to root_url, notice: t("users.password_resets.password_was_reset")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def ensure_valid_token
    @user = User.find_signed(params[:id], purpose: :password_reset)
    unless @user
      redirect_to new_users_password_reset_path, alert: t("users.password_resets.invalid_or_expired_link")
    end
  end
end
