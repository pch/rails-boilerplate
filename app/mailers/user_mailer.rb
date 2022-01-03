class UserMailer < ApplicationMailer
  def email_confirmation
    @user = params[:user]
    mail(to: @user.email, subject: default_i18n_subject)
  end

  def forgot_password
    @user = params[:user]
    mail(to: @user.email, subject: default_i18n_subject)
  end

  def password_changed
    @user = params[:user]
    @activity = params[:activity]
    @ip = @activity.ip
    @city = @activity.city
    @country = @activity.country

    mail(to: @user.email, subject: default_i18n_subject)
  end
end
