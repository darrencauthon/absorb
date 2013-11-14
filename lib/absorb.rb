require 'aws/s3'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each {|file| require file }

module Absorb
  def self.file file
    Absorb::AmazonS3.store_file file
  end
end
