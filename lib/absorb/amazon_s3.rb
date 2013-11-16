module Absorb
  class AmazonS3

    attr_reader :bucket_name

    def initialize bucket
      @bucket_name = bucket
    end

    def delete_bucket
      s3.delete(bucket_name, force: true)
    rescue
    end

    def store_file file, to
      begin
        s3.create(bucket_name)
      rescue
      end

      store_this_as file, to
    end

    private

    def s3
      AWS::S3.new
    end

    def store_this_as file, to
      s3.buckets[bucket_name].objects[to]
        .write(Pathname.new(file))
    end
  end
end
