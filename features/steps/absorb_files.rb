require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps

  before { Absorb::AmazonS3.delete_bucket }

  step 'I have a file' do
    @file = 'file.txt'
    create_a_file @file
  end

  step 'I absorb the file' do
    Absorb.file test_file(@file)
  end

  step 'the file should be uploaded to S3' do
    bucket[@file].nil?.must_equal false
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
    ENV['BUCKET']
  end
end
