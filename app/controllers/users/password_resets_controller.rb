class Users::PasswordResetsController < ApplicationController
  def create
    @user = User.find_by_normalized_email(params[:email])
    if @user
      track_activity!(action: "password_reset_requested", user: @user)
      UserMailer.with(user: @user).password_reset.deliver_later
    else
      track_activity!(action: "password_reset_requested", user: User.guest_user, metadata: { email: params[:email] })
    end

    redirect_to new_users_password_reset_path(sent: true)
  end

  def edit
    @user = User.find_signed(params[:id], purpose: :password_reset)
  end

  def update
    @user = User.find_signed!(params[:id], purpose: :password_reset)

    if @user
      if @user.update(user_params)
        track_activity!(action: "password_reset", user: @user)
        redirect_to root_url, notice: t("users.password_resets.password_was_reset")
      else
        render :edit, status: :unprocessable_entity
      end
    else
      flash[:error] = t("users.password_resets.invalid_or_expired_link")
      redirect_to new_users_password_reset_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
