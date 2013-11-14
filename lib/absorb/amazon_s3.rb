module Absorb
  module AmazonS3
    def self.store_file file

      setup_s3

      name = file.split('/')[-1]
      AWS::S3::S3Object.store(name, open(file), bucket_name)
    end

    private

    def self.setup_s3
      AWS::S3::Base.establish_connection!(
        :access_key_id     => ENV['ACCESS_KEY_ID'],
        :secret_access_key => ENV['SECRET_ACCESS_KEY']
      )

      begin
        AWS::S3::Bucket.delete(bucket_name, force: true)
      rescue
      end

      begin
        AWS::S3::Bucket.create(bucket_name)
      rescue
      end
    end

    def self.bucket_name
      ENV['BUCKET']
    end
  end
end
