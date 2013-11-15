require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps

  before do
    @s3 = Absorb::AmazonS3.new({
                                 bucket_name: ENV['BUCKET_NAME'],
                                 access_key_id: ENV['ACCESS_KEY_ID'],
                                 secret_access_key: ENV['SECRET_ACCESS_KEY'],
                               })
    @s3.delete_bucket
  end

  before do
    @guid = 'abc'
    Absorb::Guid.stubs(:generate).returns 'abc'
  end

  step 'I have a file' do
    @file = 'file.txt'
    create_a_file @file
  end

  step 'I absorb the file' do
    Absorb.file test_file(@file)
  end

  step 'the file should be uploaded to S3 in a unique folder' do
    bucket.objects["#{@guid}/#{@file}"].nil?.must_equal false
  end

  step 'a record of the upload should be made in DynamoDB' do
    Dynamoid.configure do |config|
      config.adapter = 'aws_sdk' # This adapter establishes a connection to the DynamoDB servers using Amazon's own AWS gem.
      config.namespace = "absorb_test" # To namespace tables created by Dynamoid from other tables you might have.
      config.warn_on_scan = true # Output a warning to the logger when you perform a scan rather than a query on a table.
      config.partitioning = true # Spread writes randomly across the database. See "partitioning" below for more.
      config.partition_size = 200  # Determine the key space size that writes are randomly spread across.
      config.read_capacity = 100 # Read capacity for your tables
      config.write_capacity = 20 # Write capacity for your tables
    end

    Upload.where(filename: @file).all.count.must_equal 0
  end

  def create_a_file file, content = 'x'
    File.open(test_file(file), 'w') { |file| file.write(content) }
  end

  def bucket
    AWS::S3.new.buckets[bucket_name]
  end

  def test_file file
    "temp/#{file}"
  end

  def bucket_name
    ENV['BUCKET_NAME']
  end
end
