require 'set'
require 'uri'
require 'subscription_management'

class Page < ActiveRecord::Base
  include Rakismet::Model
  include Authority::Abilities
  self.authorizer_name = 'PageAuthorizer'

  include Categories

  has_one  :page_title, class_name: "Title", as: :titleable, autosave: true, dependent: :destroy
  validates_associated :page_title
  accepts_nested_attributes_for :page_title

  has_many :history, class_name: 'PageState', dependent: :delete_all, autosave: true
  has_many :comments, as: :commentable, dependent: :delete_all
  has_many :resource_usages
  has_many :resources, through: :resource_usages

  has_many :subscriptions, as: :subscribable, dependent: :delete_all
  has_many :subscribers, through: :subscriptions, source: :user

  scope    :ordered_by_title, ->{joins(:page_title).order("titles.title")}

  rakismet_attrs :author       => proc { user.name  },
                 :author_email => proc { user.email },
                 :user_role    => proc { user.admin? ? 'administrator' : 'user' },
                 :comment_type => proc { 'page' }

  extend HistoryControl
  history_attr :content
  history_attr :user_id
  history_attr :user
  history_attr :categories
  history_attr :tags
  history_attr :title
  history_attr :item_number
  history_attr :location

  before_save       :track_title_change, :clean_collection_item


  validates :content, presence: true
  validate  :not_spam?

  include SubscriptionManagement
  after_create  :subscribe_creator
  #---------------------------------------------------------
  #---------------------------------------------------------

  def self.find_with_category(cat)
    Page.order(:title).select{ |p| p.has_category?( cat ) ? p : nil}
  end

  def self.find_with_tag(tag)
    Page.order(:title).select{ |p| p.has_tag?( tag ) }
  end

  #---------------------------------------------------------

  def has_category?(c)
    history.last.try(:has_category?, c)
  end

  def has_tag?(t)
    history.last.try(:has_tag?, t)
  end

  #---------------------------------------------------------

  def not_spam?
    if user.present?
      errors.add :content, I18n.t('errors.page.content.is_spam') if spam?
    else
      errors.add :content, I18n.t('errors.page.content.rakismet_skipped')
    end
    rescue
      errors.add :content, I18n.t('errors.page.content.rakismet_failed')
  end

  def to_param
    page_title.to_param
  end

  def title
    page_title.title
  end

  def title=(new_title)
    super
    page_title.title = new_title
  end

  def slug
    page_title.slug
  end

  def track_title_change
    if page_title.title_changed?
      self.title = page_title.title
    end
  end

  def self.find_by_slug(slug)
    joins(:page_title).where(titles: {slug: slug}).first
  end

  def self.find_by_title(title)
    joins(:page_title).where(titles: {title: title}).first
  end

  private

  def clean_collection_item
    self.item_number = nil if item_number.to_s.strip.empty?
  end
end