class UserMailer < ApplicationMailer
  def email_confirmation
    @user = params[:user]
    mail(to: @user.email, subject: default_i18n_subject)
  end

  def password_reset
    @user = params[:user]
    mail(to: @user.email, subject: default_i18n_subject)
  end
end
