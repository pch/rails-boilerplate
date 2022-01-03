class Users::EmailConfirmationsController < ApplicationController
  skip_before_action :require_confirmed_email
  before_action :require_authentication, only: %i[index create]

  def index
    redirect_to root_url if Current.user.email_confirmed?

    flash.now.alert = t("users.email_confirmations.email_not_confirmed")
  end

  def show
    @user = User.find_signed(params[:id], purpose: :email_confirmation)
    if @user
      unless @user.email_confirmed?
        @user.confirm_email!
        track_activity!(action: "email_confirmed", user: @user)
      end

      redirect_to root_url, notice: t("users.email_confirmations.email_confirmed")
    else
      redirect_to users_email_confirmations_path, alert: t("users.email_confirmations.link_invalid_or_expired")
    end
  end

  def create
    track_activity!(action: "email_confirmation_link_resent")
    UserMailer.with(user: Current.user).email_confirmation.deliver_later

    redirect_to users_email_confirmations_path, notice: t("users.email_confirmations.link_sent")
  end
end
