require 'aws/s3'
require 'dynamoid'
require 'uuid'
require 'seam'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/absorb/steps/*.rb'].each {|file| require file }

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

  def self.restore package_id, directory
    ::FileUtils.mkdir_p 'temp/first_restore' unless ::File.directory? 'temp/first_restore'
    ::File.open("temp/first_restore/file.txt", 'w') { |f| f.write('') }
  end

end
