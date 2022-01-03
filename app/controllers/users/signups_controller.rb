class Users::SignupsController < ApplicationController
  before_action :disallow_logged_in_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      track_activity!(action: "signup", user: @user)
      log_in(@user)
      UserMailer.with(user: @user).email_confirmation.deliver_later

      redirect_to after_sign_up_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :accept_terms)
  end
end
