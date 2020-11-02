class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github twitter]

  include Answerable
  include Questionable

  has_many :rates, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    case auth.provider
    when 'github'
      OauthServices::GithubService.new.call(uid: auth.uid, email: auth.info[:email])
    when 'twitter'
      OauthServices::TwitterService.new.call(uid: auth.uid)
    end
  end

  def author_of?(object)
    id == object.try(:user_id)
  end

  def regards
    answers.map(&:regard)
  end

  def rated?(record)
    rates.where(ratable: record).present?
  end

  def confirmation_required?
    authorizations.where(provider: 'twitter').present?
  end
end
