require 'aws/s3'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each {|file| require file }

module Absorb
  def self.file file
    s3 = Absorb::AmazonS3.new({
                                bucket_name: ENV['BUCKET_NAME'],
                                access_key_id: ENV['ACCESS_KEY_ID'],
                                secret_access_key: ENV['SECRET_ACCESS_KEY'],
                              })
    s3.store_file file
  end
end
