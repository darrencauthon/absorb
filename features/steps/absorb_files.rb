require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps

  before do
    @s3 = Absorb::AmazonS3.new
    @s3.delete_bucket

    @guid = 'abc'
    Absorb::Guid.stubs(:generate).returns 'abc'

    Absorb::Upload.all.each { |u| u.delete }
    Absorb::File.all.each   { |f| f.delete }
  end

  step 'I have a file' do
    @file = 'file.txt'
    create_a_file @file
  end

  step 'I have two files' do
    @files = ['file2.txt', 'file3.txt']
    @files.each { |f| create_a_file f }
  end

  step 'I have two files of different depth' do
    @files = ['dog/file4.txt', 'dog/cat/file5.txt']
    @files.each { |f| create_a_file f }
  end

  step 'I absorb the file' do
    Absorb.files [test_file(@file)]
  end

  step 'I absorb the files' do
    Absorb.files(@files.map  { |f| test_file(f) } )
  end

  step 'the file should be uploaded to S3 in a unique folder' do
    bucket.objects["#{@guid}/#{@file}"].nil?.must_equal false
  end

  step 'the files should be uploaded to S3 in a unique folder' do
    @files.each do |file|
      bucket.objects["#{@guid}/#{file}"].nil?.must_equal false
    end
  end

  step 'a record of the upload should be made in DynamoDB' do
    Absorb::Upload.where(uuid: @guid).all.count.must_equal 1
  end

  step 'details of the file upload should be made' do
    files = Absorb::File.where(uuid: @guid).all

    files.count.must_equal 1
    files.first.name.must_equal @file
  end

  step 'details of the file uploads should be made' do
    files = Absorb::File.where(uuid: @guid).all

    files.count.must_equal @files.count

    files.each do |file|
      @files.include?(file.name).must_equal true
    end
  end

  def directories_of file
    dirs = file.split('/').reverse
    dirs.shift

    previous = ""
    dirs.reverse.map do |d| 
      d = [previous, d].select { |x| x != '' }.join('/')
      previous = d
      test_directory d
    end
  end

  def create_a_file file, content = 'x'
    directories_of(file).each do |dir|
      begin
        Dir.mkdir dir
      rescue
      end
    end
    File.open(test_file(file), 'w') { |file| file.write(content) }
  end

  def bucket
    AWS::S3.new.buckets[bucket_name]
  end

  def test_file file
    "temp/#{file}"
  end

  def test_directory directory
    test_file directory
  end

  def bucket_name
    ENV['BUCKET_NAME']
  end
end
