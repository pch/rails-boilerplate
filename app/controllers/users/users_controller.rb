class Users::UsersController < ApplicationController
  skip_before_action :require_confirmed_email
  before_action :require_authentication
  before_action :load_sessions

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user

    if @user.update_with_password(user_params)
      handle_changed_email
      handle_changed_password

      redirect_to edit_users_user_path, notice: t("users.user.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
  end

  def handle_changed_email
    return unless @user.email_previously_changed?

    track_activity!(action: "email_changed", metadata: { previous_email: @user.email_previously_was })
    UserMailer.with(user: @user).email_confirmation.deliver_later
  end

  def handle_changed_password
    return unless @user.password_digest_previously_changed?

    activity = track_activity!(action: "password_changed")
    UserMailer.with(user: @user, activity: activity).password_changed.deliver_later
  end

  def load_sessions
    @sessions = Current.user.sessions.active.order(accessed_at: :desc).includes(:last_activity)
  end
end
