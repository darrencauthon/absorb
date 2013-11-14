module Absorb
  class AmazonS3

    attr_reader :bucket_name

    def initialize options
      @options = options
      @bucket_name = options[:bucket_name]
      setup
    end

    def setup
      AWS::S3::Base.establish_connection!(
        :access_key_id     => @options[:access_key_id],
        :secret_access_key => @options[:secret_access_key]
      )
    end

    def delete_bucket
      AWS::S3::Bucket.delete(bucket_name, force: true)
    rescue
    end

    def store_file file
      begin
        AWS::S3::Bucket.create(bucket_name)
      rescue
      end

      store_this_as file, file.split('/')[-1]
    end

    private

    def store_this_as file, name
      AWS::S3::S3Object.store("#{Absorb::Guid.generate}/#{name}", open(file), bucket_name)
    end
  end
end
