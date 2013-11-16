require 'aws/s3'
require 'dynamoid'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each {|file| require file }

module Absorb
  def self.startup
    AWS.config(access_key_id:       settings[:access_key_id],
               secret_access_key:   settings[:secret_access_key],
               dynamo_db_endpoint: 'dynamodb.us-east-1.amazonaws.com')
  end

  def self.settings
    {
      bucket_name:       ENV['BUCKET_NAME'],
      access_key_id:     ENV['ACCESS_KEY_ID'],
      secret_access_key: ENV['SECRET_ACCESS_KEY'],
    }
  end

  def self.file file
    s3 = Absorb::AmazonS3.new settings[:bucket_name]
    absorber = Absorb::Absorber.new s3
    absorber.absorb file
  end
end
