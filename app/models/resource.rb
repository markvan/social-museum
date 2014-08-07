require 'uri'

class Resource < ActiveRecord::Base
  has_secretary

  include Authority::Abilities
  self.authorizer_name = 'ResourceAuthorizer'

  has_many :resource_usages
  has_many :pages, through: :resource_usages

  belongs_to :user

  tracks_association :pages
  tracks_association :user

  validates :title, uniqueness: true, presence: true
  validates :source, presence: true
  validate :validate_url

  def source
    url
  end

  def file
    @upload
  end

  def file=(new_file)
    if new_file.present?
      @upload =  Upload.create_upload(new_file)
      self.url = @upload.file.url
    end
  end

  private

  def validate_url
    if url !~ URI::regexp(['http','https'])
      errors.add :url, 'URL should be a valid link'
    end
  end
end