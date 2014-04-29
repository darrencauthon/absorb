require 'aws/s3'
require 'dynamoid'
require 'uuid'
require 'seam'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/absorb/steps/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/cli/*.rb'].each { |f| require f }

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
    ::FileUtils.mkdir_p directory unless ::File.directory? directory
    absorb_file = Absorb::File.all.first
    package = Absorb::Package.find(package_id)
    files = Absorb::File.where(uuid: package.uuid).to_a
    amazon_s3 = Absorb::AmazonS3.new
    files.each do |file|
      segments = "#{directory}/#{file.name}".split('/')
      segments = segments[0...segments.count-1]
      new_directory = segments.join('/')
      ::FileUtils.mkdir_p new_directory unless ::File.directory? new_directory
      amazon_s3.retrieve_file("#{file.storage_id}/#{file.name}", "#{directory}/#{file.name}")
    end
  end

end
