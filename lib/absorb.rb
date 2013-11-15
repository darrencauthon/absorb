require 'aws/s3'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each {|file| require file }

module Absorb
  def self.file file
    settings = {
                 bucket_name:       ENV['BUCKET_NAME'],
                 access_key_id:     ENV['ACCESS_KEY_ID'],
                 secret_access_key: ENV['SECRET_ACCESS_KEY'],
               }

    AWS.config(access_key_id:     settings[:access_key_id],
               secret_access_key: settings[:secret_access_key])

    s3 = Absorb::AmazonS3.new settings

    absorber = Absorb::Absorber.new s3
    absorber.absorb file
  end
end
