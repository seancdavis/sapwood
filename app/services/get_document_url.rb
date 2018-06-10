# frozen_string_literal: true

require 'aws-sdk'

class GetDocumentUrl
  attr_accessor :document, :expires_in

  def initialize(options = {})
    @document = options[:document]
    raise 'You must provide a document.' if @document.blank?
    set_options(options)
  end

  def self.call(options = {})
    new(options).call
  end

  def call
    return @document.url unless @document.private?
    s3_object.presigned_url(:get, expires_in: @options[:expires_in])
  end

  private

    def set_options(options)
      @options = options.reverse_merge(expires_in: 60)
    end

    # ---------------------------------------- AWS Setup / Credentials

    def key
      @key ||= ENV['AWS_ACCESS_KEY_ID']
    end

    def secret
      @secret ||= ENV['AWS_SECRET_ACCESS_KEY']
    end

    def bucket_name
      @bucket_name ||= ENV['AWS_BUCKET']
    end

    def region
      'us-east-1'
    end

    def s3_credentials
      Aws::Credentials.new(key, secret)
    end

    def s3_client
      @s3_client ||= Aws::S3::Client.new region: region,
                                         access_key_id: key,
                                         secret_access_key: secret
    end

    # ---------------------------------------- Document Helpers

    def document_url
      @document_url ||= URI.escape(@document.url)
    end

    # ---------------------------------------- S3 Helpers

    def s3_bucket
      @s3_bucket ||= Aws::S3::Bucket.new(bucket_name, client: s3_client)
    end

    def s3_object
      @s3_object ||= s3_bucket.object(s3_file_path)
    end

    def s3_dir
      @s3_dir ||= document_url.split('/')[3..-2].join('/')
    end

    def s3_file_path
      "#{s3_dir}/#{@document.filename}"
    end
end
