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

  step 'I have a file' do
    @file = 'file.txt'
    create_a_file @file
  end

  step 'I absorb the file' do
    Absorb.file test_file(@file)
  end

  step 'the file should be uploaded to S3 in a unique folder' do
    bucket["GUID/#{@file}"].nil?.must_equal false
  end

  def create_a_file file, content = 'x'
    File.open(test_file(file), 'w') { |file| file.write(content) }
  end

  def bucket
    AWS::S3::Bucket.find bucket_name
  end

  def test_file file
    "temp/#{file}"
  end

  def bucket_name
    ENV['BUCKET_NAME']
  end
end
