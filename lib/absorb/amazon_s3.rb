module Absorb
  class AmazonS3

    attr_reader :bucket_name

    def initialize bucket
      @bucket_name = bucket
    end

    def delete_bucket
      AWS::S3.new.delete(bucket_name, force: true)
    rescue
    end

    def store_file file
      begin
        AWS::S3.new.create(bucket_name)
      rescue
      end

      store_this_as file, file.split('/')[-1]
    end

    private

    def store_this_as file, name
      AWS::S3.new.buckets[bucket_name].objects["#{Absorb::Guid.generate}/#{name}"]
        .write(Pathname.new(file))
    end
  end
end
