require 'aws-sdk'
require 'rmagick'

class ProcessImage

  include Magick

  def initialize(options = {})
    raise "You must provide a document." if options[:document].blank?
    @document = options[:document]
  end

  def self.call(options = {})
    new(options).call
  end

  def call
    download_file
    orient_image
    upload_file
    delete_file
  end

  private

    # ---------------------------------------- AWS Setup / Credentials

    def key
      @key ||= begin
        return ENV['aws_access_key_id'] if Sapwood.config.amazon_aws.blank?
        Sapwood.config.amazon_aws.access_key_id
      end
    end

    def secret
      @secret ||= begin
        return ENV['aws_secret_access_key'] if Sapwood.config.amazon_aws.blank?
        Sapwood.config.amazon_aws.secret_access_key
      end
    end

    def bucket
      @bucket ||= begin
        return ENV['aws_bucket'] if Sapwood.config.amazon_aws.blank?
        Sapwood.config.amazon_aws.bucket
      end
    end

    def region
      'us-east-1'
    end

    def s3_credentials
      Aws::Credentials.new(key, secret)
    end

    def s3
      @s3 ||= Aws::S3::Client.new :region => region,
                                  :access_key_id => key,
                                  :secret_access_key => secret
    end

    # ---------------------------------------- File References

    def document_url
      @document_url ||= URI.escape(@document.url)
    end

    def temp_filename
      @temp_filename ||= SecureRandom.hex(24) + '.' + @document.file_ext
    end

    def temp_file_path
      @temp_file_path ||= begin
        FileUtils.mkdir_p(Rails.root.join('tmp', 'sapwood').to_s)
        Rails.root.join('tmp', 'sapwood', temp_filename)
      end
    end

    def s3_dir
      @s3_dir ||= document_url.split('/')[3..-2].join('/')
    end

    def s3_file_path
      @s3_file_path ||= "#{s3_dir}/#{@document.filename}"
    end

    # ---------------------------------------- Actions

    def download_file
      s3.get_object :response_target => temp_file_path,
                    :bucket => bucket, :key => s3_file_path
    end

    def orient_image
      system("convert -auto-orient #{temp_file_path} #{temp_file_path}")
    end

    def upload_file
      File.open(temp_file_path, 'rb') do |file|
        s3.put_object :bucket => bucket, :key => s3_file_path, :body => file,
                      :acl => 'public-read'
      end
    end

    def delete_file
      FileUtils.rm(temp_file_path)
    end

end
