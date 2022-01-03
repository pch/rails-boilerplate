module Users
  module Authentication
    extend ActiveSupport::Concern

    MIN_PASSWORD_LENGTH = 6
    DEFAULT_ROLE = "user"
    SYSTEM_USER_ID = -1
    GUEST_USER_ID = -2
    SYSTEM_ROLES = %w[system guest].freeze

    included do
      attr_accessor :current_password

      has_many :sessions, class_name: "Users::Session", dependent: :destroy
      has_many :activities, class_name: "Users::Activity", dependent: :delete_all

      has_secure_password

      encrypts :name, deterministic: true
      encrypts :email, deterministic: true

      validates :name, presence: true
      validates :email, presence: true
      validates :email, uniqueness: { case_sensitive: false }
      validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
      validates :password, length: { minimum: MIN_PASSWORD_LENGTH, allow_blank: true }, not_pwned: true
      validates :accept_terms, acceptance: { on: :create }

      before_validation :normalize_email
      before_create do
        self.terms_accepted_at = Time.zone.now if accept_terms
        self.role ||= DEFAULT_ROLE
      end

      before_update :unconfirm_email, if: :email_changed?
    end

    module ClassMethods
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

      def system_user
        User.find_by(id: SYSTEM_USER_ID) || create_system_user!
      end

      def guest_user
        User.find_by(id: GUEST_USER_ID) || create_guest_user!
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

      def create_system_user!
        User.create!(
          id: SYSTEM_USER_ID,
          name: "system",
          email: "system-#{SecureRandom.hex}@system",
          password: SecureRandom.urlsafe_base64(40),
          role: "system"
        )
      end

      def create_guest_user!
        User.create!(
          id: GUEST_USER_ID,
          name: "guest",
          email: "guest-#{SecureRandom.hex}@system",
          password: SecureRandom.urlsafe_base64(40),
          role: "guest"
        )
      end
    end

    def logged_in?
      SYSTEM_ROLES.exclude?(role)
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
      signed_id(purpose: :email_confirmation, expires_in: 24.hours)
    end

    # Stolen from devise
    # https://rdoc.info/gems/devise/Devise/Models/DatabaseAuthenticatable#update_with_password-instance_method
    def update_with_password(params)
      current_password = params.delete(:current_password)

      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
      end

      # Fetch user from db again, because for some reason authenticate
      # always returns false when called on self
      if User.find(id).authenticate(current_password)
        update(params)
      else
        assign_attributes(params)
        valid?
        errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end
    end

    private

    def normalize_email
      self.email = self.class.normalize_email(email)
    end

    def unconfirm_email
      self.email_confirmed_at = nil
    end
  end
end
