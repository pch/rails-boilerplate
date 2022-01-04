class Users::Session < ApplicationRecord
  include Hashid::Rails

  SESSION_TTL = 1.month

  belongs_to :user
  has_many :activities, class_name: "Users::Activity", dependent: :delete_all
  has_one :last_activity, -> { order(id: :desc) }, class_name: "Users::Activity", dependent: :destroy

  has_secure_token :token, length: 36

  scope :active, -> { where(revoked_at: nil).where("accessed_at >= ?", SESSION_TTL.ago) }

  def self.authenticate(token)
    active.find_by(token: token)
  end

  def self.create_new_session!(user)
    create!(user: user, accessed_at: Time.zone.now)
  end

  def to_param
    hashid
  end

  def log_access
    self.accessed_at = Time.zone.now
    save
  end

  def revoke!
    self.revoked_at = Time.zone.now
    save!
  end

  def revoked?
    revoked_at.present?
  end
end
