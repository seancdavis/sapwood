require 'aws-sdk'
require 'rmagick'

class ProcessImages

  include Magick

  def initialize(options = {})
    raise 'You must provide a document.' if options[:document].blank?
    @document = options[:document]
  end

  def self.call(options = {})
    new(options).call
  end

  def call
    download_file
    orient_image
    create_image_versions
    upload_files
    delete_files
    @document.processed!
    true
  end

  private

    # ---------------------------------------- AWS Setup / Credentials

    def key
      @key ||= ENV['AWS_ACCESS_KEY_ID']
    end

    def secret
      @secret ||= ENV['AWS_SECRET_ACCESS_KEY']
    end

    def bucket
      @bucket ||= ENV['AWS_BUCKET']
    end

    def region
      'us-east-1'
    end

    def s3_credentials
      Aws::Credentials.new(key, secret)
    end

    def s3
      @s3 ||= Aws::S3::Client.new region: region,
                                  access_key_id: key,
                                  secret_access_key: secret
    end

    # ---------------------------------------- File References

    def document_url
      @document_url ||= URI.escape(@document.url)
    end

    def temp_filename
      @temp_filename ||= SecureRandom.hex(24) + '.' + @document.file_ext
    end

    def temp_filename_no_ext
      @temp_filename_no_ext ||= temp_filename.split('.').first
    end

    def temp_file_path
      @temp_file_path ||= begin
        FileUtils.mkdir_p(Rails.root.join('tmp', 'sapwood').to_s)
        Rails.root.join('tmp', 'sapwood', temp_filename)
      end
    end

    def temp_version_path(name)
      filename = "#{temp_filename_no_ext}_#{name}.#{@document.file_ext}"
      Rails.root.join('tmp', 'sapwood', filename)
    end

    def temp_cropped_version_path(name)
      f = "#{temp_filename_no_ext}_#{name}_crop.#{@document.file_ext}"
      Rails.root.join('tmp', 'sapwood', f)
    end

    def s3_dir
      @s3_dir ||= document_url.split('/')[3..-2].join('/')
    end

    def s3_file_path(version = nil)
      if version.nil?
        "#{s3_dir}/#{@document.filename}"
      else
        f = "#{@document.filename_no_ext}_#{version}.#{@document.file_ext}"
        "#{s3_dir}/#{f}"
      end
    end

    def image_versions
      @image_versions ||= {
        xsmall: 50,
        small: 200,
        medium: 450,
        large: 800,
        xlarge: 1400
      }
    end

    def upload_paths
      paths = { temp_file_path => s3_file_path }
      image_versions.each do |name, dim|
        paths[temp_version_path(name)] = s3_file_path(name.to_s)
        paths[temp_cropped_version_path(name)] = s3_file_path("#{name}_crop")
      end
      paths
    end

    # ---------------------------------------- Actions

    def download_file
      s3.get_object response_target: temp_file_path,
                    bucket: bucket, key: s3_file_path
    end

    def orient_image
      system("convert -auto-orient #{temp_file_path} #{temp_file_path}")
    end

    def create_image_versions
      image_versions.each do |name, dimension|
        img = Image.read(temp_file_path)[0]
        img.resize_to_fit(dimension).write(temp_version_path(name))
        img.resize_to_fill(dimension).write(temp_cropped_version_path(name))
      end
    end

    def upload_files
      upload_paths.each do |temp_path, s3_path|
        File.open(temp_path, 'rb') do |file|
          s3.put_object bucket: bucket, key: s3_path, body: file,
                        acl: 'public-read'
        end
      end
    end

    def delete_files
      upload_paths.each { |temp_path, s3_path| FileUtils.rm(temp_path) }
    end

end
