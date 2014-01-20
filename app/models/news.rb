class News
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include ActiveModel::ForbiddenAttributesProtection
  include Trackable
  include Seoable

  field :time, type: Time
  index({enabled: 1, time: 1})
  scope :after_now, -> { where(:time.gt => Time.now) }

  field :excerpt, type: String
  field :content, type: String

  unless RocketCMS.configuration.news_image_styles.nil?
    include Mongoid::Paperclip
    has_mongoid_attached_file :image, styles: RocketCMS.configuration.news_image_styles
  end

  validates_presence_of :name, :content

  before_validation do
    self.time = Time.now if self.time.blank?
  end

  include ManualSlug
  def report_slug
    time.strftime('%Y-%m-%d') + '-' + name[0..20]
  end
  manual_slug :report_slug

  def html5_date
    time.strftime('%Y-%m-%d')
  end

  def format_date
    time.strftime('%d.%m.%Y')
  end

  paginates_per RocketCMS.configuration.news_per_page

  include SmartExcerpt
  smart_excerpt :excerpt, :content

  rails_admin do
    navigation_label 'Новости'

    list do
      field :enabled, :toggle
      field :time
      field :name
      unless RocketCMS.configuration.news_image_styles.nil?
        field :image
      end
      field :excerpt
    end

    edit do
      field :name
      field :time
      unless RocketCMS.configuration.news_image_styles.nil?
        field :image
      end
      field :excerpt
      field :content, :ckeditor

      group :seo, &Seoable.seo_config
    end
  end
end
