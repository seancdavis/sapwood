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
    return @document.url.to_s unless @document.private?
    s3_object.presigned_url(:get, expires_in: @options[:expires_in])
  end

  private

    def set_options(options)
      @options = options.reverse_merge(expires_in: 60)
    end

    def s3_credentials
      Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
    end

    def s3_client
      @s3_client ||= Aws::S3::Client.new region: 'us-east-1',
                                         access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                         secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    end

    # ---------------------------------------- S3 Helpers

    def s3_bucket
      @s3_bucket ||= Aws::S3::Bucket.new(ENV['AWS_BUCKET'], client: s3_client)
    end

    def s3_object
      @s3_object ||= s3_bucket.object(@document.path)
    end

end
