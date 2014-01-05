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

    def retrieve_file file, local_location
      
        #.write("~/desktop/test.txt")
      
      large_object = s3.buckets[bucket_name]
                      .objects[file].read
                    
      ::File.open(local_location, 'wb') do |file|
        file.write large_object
      end

      #::File.open(local_location, 'wb') do |file|
        #large_object = s3.buckets[bucket_name]
                        #.objects[file]
        #large_object.read do |chunk|
          #raise 'k'
          #file.write(chunk)
        #end
      #end
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
