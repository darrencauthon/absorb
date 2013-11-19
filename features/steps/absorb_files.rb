require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps

  before do
    @s3 = Absorb::AmazonS3.new
    @s3.delete_bucket

    @guid = 'abc'
    Absorb::Guid.stubs(:generate).returns 'abc'

    Absorb::Upload.all.each { |u| u.delete }
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
    Absorb::Upload.where(uuid: @guid).all.count.must_equal 1
  end

  step 'details of the file upload should be made' do
    Absorb::File.where(uuid: @guid).all.count.must_equal 1
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
