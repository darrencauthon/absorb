module Absorb

  class AmazonS3

    def initialize
      Amazon.startup
    end

    def delete_bucket
      s3.delete(bucket_name, force: true)
    rescue
    end

    def store_file file, to
      create_bucket
      s3.buckets[bucket_name]
        .objects[to]
        .write(Pathname.new(file))
    end

    def retrieve_file key, local_location
      bucket = s3.buckets[bucket_name]
      object = bucket.objects[key]

      file = ::File.open(local_location, 'wb') 
      object.read { |c| file.write c }
      file.close
    end

    def bucket_name
      Absorb.settings[:bucket_name]
    end

    private

    def create_bucket
      s3.create bucket_name
    rescue
    end

    def s3
      AWS::S3.new
    end

  end

end
