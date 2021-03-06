class User < ActiveRecord::Base

  include Authority::UserAbilities
  include Authority::Abilities

  #todo check devise parameterisation :lockable, :timeoutable, :confirmable,
  if Rails.env.test?
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :omniauthable, :omniauth_providers => [:twitter]
  else
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :omniauthable, :omniauth_providers => [:twitter]
  end

  has_many :comments
  has_many :pages
  has_many :collection_items
  has_many :resources

  has_many :subscriptions

  has_many :subscribed_collection_items, through: :subscriptions, source: :subscribable, source_type: 'CollectionItem'
  has_many :subscribed_pages,            through: :subscriptions, source: :subscribable, source_type: 'Page'
  #todo has_many :subscribed_resources,        through: :subscribable, source: :categorisable, source_type: 'Resource'

  after_create :make_first_user_admin

  # -----------------------------------------------------------

  def self.process_omniauth(auth)

    User.where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      #TODO clean up - easy
      user.skip_confirmation!
      user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"

      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
      user.name = auth.info.nickname
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def name_or_anonymous_user
    name == nil || name == '' ? 'An anonymous user' : name
  end

  def guest?
    !persisted?
  end

  private

  def make_first_user_admin
    if User.count == 1
      u = User.first
      u.admin = true
      u.save
    end
  end

end