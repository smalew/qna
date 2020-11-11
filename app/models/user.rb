# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  admin                  :boolean
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github twitter]

  include Answerable
  include Questionable

  has_many :rates, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all

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
