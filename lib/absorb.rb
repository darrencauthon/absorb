require 'aws/s3'
require 'dynamoid'
require 'uuid'
require 'seam'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each {|file| require file }

module Absorb

  def self.settings
    {
      bucket_name:          ENV['BUCKET_NAME'],
      access_key_id:        ENV['ACCESS_KEY_ID'],
      secret_access_key:    ENV['SECRET_ACCESS_KEY'],
      dynamodb_upload:      ENV['DYNAMODB_UPLOAD']
    }
  end

  def self.files files
    Amazon.startup
    Absorb::Absorber.new.absorb files
  end

end
