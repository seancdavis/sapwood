require 'aws-sdk'
require 'rmagick'

class ProcessAvatar

  include Magick

  def initialize(options = {})
    raise "You must provide a user." if options[:user].blank?
    @user = options[:user]
  end

  def self.call(options = {})
    new(options).call
  end

  def call
    download_file
    orient_image
    resize_image
    upload_image
    delete_image
    @user.update_columns(:avatar_url => dest_url)
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
      @s3 ||= Aws::S3::Client.new :region => region,
                                  :access_key_id => key,
                                  :secret_access_key => secret
    end

    # ---------------------------------------- File References

    def image_url
      @image_url ||= URI.escape(@user.avatar_url)
    end

    def filename
      image_url.split('/').last
    end

    def file_ext
      image_url.split('.').last
    end

    def temp_filename
      @temp_filename ||= SecureRandom.hex(24) + '.' + file_ext
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

    def temp_resized_path
      Rails.root.join('tmp', 'sapwood', "_#{filename}")
    end

    def s3_dir
      @s3_dir ||= image_url.split('/')[3..-2].join('/')
    end

    def s3_file_path
      "#{s3_dir}/#{filename}"
    end

    def s3_file_dest
      "#{s3_dir}/_#{filename}"
    end

    def dest_url
      "#{image_url.split('/')[0..-2].join('/')}/_#{filename}"
    end

    def upload_paths
      paths = { temp_file_path => s3_file_path }
    end

    # ---------------------------------------- Actions

    def download_file
      s3.get_object :response_target => temp_file_path,
                    :bucket => bucket, :key => s3_file_path
    end

    def orient_image
      system("convert -auto-orient #{temp_file_path} #{temp_file_path}")
    end

    def resize_image
      img = Image.read(temp_file_path)[0]
      img.resize_to_fill(100).write(temp_resized_path)
    end

    def upload_image
      File.open(temp_resized_path, 'rb') do |file|
        s3.put_object :bucket => bucket, :key => s3_file_dest, :body => file,
                      :acl => 'public-read'
      end
    end

    def delete_image
      FileUtils.rm(temp_file_path)
      FileUtils.rm(temp_resized_path)
    end

end
