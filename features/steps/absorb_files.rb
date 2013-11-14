require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps

  before { setup_s3 }

  step 'I have a file' do
    @file = 'file.txt'
    create_a_file @file
  end

  step 'I absorb the file' do
    Absorb.file @file
  end

  step 'the file should be uploaded to S3' do
    #AWS::S3::S3Object.store(@file, open(test_file(@file)), bucket_name)
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

  def setup_s3

    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['ACCESS_KEY_ID'],
      :secret_access_key => ENV['SECRET_ACCESS_KEY']
    )

    begin
      AWS::S3::Bucket.delete(bucket_name, force: true)
    rescue
    end

    begin
      AWS::S3::Bucket.create(bucket_name)
    rescue
    end
  end
end
