# frozen_string_literal: true

class Document < ApplicationRecord

  # ---------------------------------------- Associations

  belongs_to :property, touch: true

  # ---------------------------------------- Scopes

  default_scope { where(archived: false) }

  scope :alpha, -> { order(title: :asc) }
  scope :starting_with, ->(letter) { where('title like ?', "#{letter}%") }
  scope :starting_with_number, -> { where('title ~* ?', '^\d(.*)?') }

  # ---------------------------------------- Callbacks

  after_create :process_images!

  after_save :set_title_if_blank

  # ---------------------------------------- Instance Methods

  def filename
    url.split('/').last
  end

  def filename_no_ext
    filename.split('.')[0..-2].join('.')
  end

  def file_ext
    url.split('.').last.downcase
  end

  def safe_url
    URI.encode(url)
  end

  def uri
    URI.parse(safe_url)
  end

  def s3_base
    "#{uri.scheme}://#{uri.host}"
  end

  def s3_dir
    uri.path.split('/').reject(&:blank?)[0..-2].join('/')
  end

  def version(name, crop = false)
    return safe_url.to_s if !processed? || !image?
    alt = crop ? '_crop' : nil
    filename = "#{filename_no_ext}_#{name}#{alt}.#{file_ext}"
    URI.encode("#{s3_base}/#{s3_dir}/#{filename}")
  end

  def image?
    %(jpeg jpg png gif svg).include?(file_ext)
  end

  def archive!
    update_columns(archived: true)
  end

  def as_json(options = {})
    response = {
      id: id,
      title: title,
      url: url
    }
    return response if !processed? || !image?
    response[:versions] = {}
    %w(xsmall small medium large xlarge).each do |v|
      response[:versions][:"#{v}"] = version(v, false)
      response[:versions][:"#{v}_crop"] = version(v, true)
    end
    response
  end

  def process_images!
    return nil if Rails.env.test?
    ProcessImages.delay.call(document: self) if image? && !processed?
  end

  def processed!
    update_columns(processed: true)
  end

  # ---------------------------------------- Private Methods

  private

    def set_title_if_blank
      if title.blank?
        update_columns(title: url.split('/').last.split('.').first.titleize)
      end
    end

end
