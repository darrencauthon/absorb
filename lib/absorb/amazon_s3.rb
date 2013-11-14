module Absorb
  module AmazonS3

    def self.setup_s3
      AWS::S3::Base.establish_connection!(
        :access_key_id     => ENV['ACCESS_KEY_ID'],
        :secret_access_key => ENV['SECRET_ACCESS_KEY']
      )
    end

    def self.delete_bucket
      setup_s3
      AWS::S3::Bucket.delete(bucket_name, force: true)
    rescue
    end

    def self.store_file file
      setup_s3

      begin
        AWS::S3::Bucket.create(bucket_name)
      rescue
      end

      store_this_as file, file.split('/')[-1]
    end

    private

    def self.store_this_as file, name
      AWS::S3::S3Object.store(name, open(file), bucket_name)
    end

    def self.bucket_name
      ENV['BUCKET']
    end
  end
end
