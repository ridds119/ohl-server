class User < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  include Rails.application.routes.url_helpers
  # has_one_base64_attached :avatar
  has_one_attached :avatar
  enum role: [:user, :admin]
  # serialize :ids, Array
  after_initialize :set_default_role, :if => :new_record?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtBlacklist
  

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false}

  def get_avatar_url
    url_for(self.avatar)
  end
  protected
    def set_default_role
      self.role ||= :user
    end

end
