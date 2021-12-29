class User < ApplicationRecord
  MIN_PASSWORD_LENGTH = 6

  has_many :sessions, class_name: "Users::Session", dependent: :destroy
  has_many :activities, class_name: "Users::Activity", dependent: :delete_all

  has_secure_password

  encrypts :name, deterministic: true
  encrypts :email, deterministic: true

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP, allow_blank: true}
  validates :password, length: {minimum: MIN_PASSWORD_LENGTH, allow_blank: true}, not_pwned: true
  validates :accept_terms, acceptance: {on: :create}

  before_validation :normalize_email
  before_create do
    self.terms_accepted_at = Time.zone.now if accept_terms
  end

  class << self
    def authenticate_with_email_and_password(email, password)
      user = find_by_normalized_email(email)
      if user && password.present?
        if user.authenticate(password)
          user
        end
      else
        prevent_timing_attack
      end
    end

    def find_by_normalized_email(email)
      find_by(email: normalize_email(email))
    end

    def normalize_email(email)
      email.to_s.downcase.gsub(/\s+/, "").presence
    end

    private

    # Initializes a new user with a dummy pasword, forcing bcrypt hash calculation.
    # We want to call bcrypt for non-existing users to ensure consistent response time,
    # making it harder for attackers to guess whether someone has an account with the
    # given email.
    #
    # Credit: https://github.com/thoughtbot/clearance/issues/636
    def prevent_timing_attack
      User.new(password: "dummy password")
      nil
    end
  end

  def email_confirmed?
    email_confirmed_at.present?
  end

  def confirm_email!
    self.email_confirmed_at = Time.zone.now
    save!
  end

  def password_reset_token
    signed_id(purpose: :password_reset, expires_in: 1.hour)
  end

  def email_confirmation_token
    signed_id(purpose: :email_confirmation, expires_in: 1.hour)
  end

  private

  def normalize_email
    self.email = self.class.normalize_email(email)
  end
end
