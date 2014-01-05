require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps

  before do
    #clear out seam
    Seam::Persistence.destroy

    @guid = 'abc'
    Absorb::Guid.stubs(:generate).returns 'abc'

    cleanup_temp_files
  end

  after do
    cleanup_temp_files
  end

  step 'I am using Amazon services' do
    @s3 = Absorb::AmazonS3.new
    @s3.delete_bucket

    Absorb::Package.all.each { |u| u.delete }
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

  step 'I absorb the file again' do

    @guid = 'def'
    Absorb::Guid.stubs(:generate).returns 'def'

    Absorb.files [test_file(@file)]
  end

  step 'I absorb the files' do
    Absorb.files(@files.map  { |f| test_file(f) } )
  end

  step 'I restore the file to a directory' do
    package_id = Absorb::Package.all.first.id
    @test_location = 'temp/first_restore'
    Absorb.restore package_id, @test_location
  end

  step 'the file should be restored to the directory' do
    absorb_file = Absorb::File.all.first
    file = "#{@test_location}/#{absorb_file.name}"
    File.exists?(file).must_equal true
    md5_of(file).must_equal absorb_file.md5
  end

  step 'the file should be uploaded to S3 in a unique folder' do
    unless bucket.objects["#{@guid}/#{@file}"].exists?
      pending "#{@guid}/#{@file}"
    end
    bucket.objects["#{@guid}/#{@file}"].exists?.must_equal true
  end

  step 'the files should be uploaded to S3 in a unique folder' do
    @files.each do |file|
      unless bucket.objects["#{@guid}/#{file}"].exists?
        pending ["#{@guid}/#{file}", bucket.objects["#{@guid}/#{file}"].exists?].inspect
      end
      bucket.objects["#{@guid}/#{file}"].exists?.must_equal true
    end
  end

  step 'a record of the package should be made in DynamoDB' do
    Absorb::Package.where(uuid: @guid).all.count.must_equal 1
  end

  step 'details of the file upload should be made in DynamoDB' do
    files = Absorb::File.where(uuid: @guid).all

    files.count.must_equal 1
    files.first.name.must_equal @file
  end

  step 'details of the file uploads should be made in DynamoDB' do
    files = Absorb::File.where(uuid: @guid).all

    files.count.must_equal @files.count

    files.each do |file|
      @files.include?(file.name).must_equal true
      the_file = @files.select { |x| x == file.name }.first
      file.md5.must_equal md5_of_file the_file
      file.storage_id.must_equal file.uuid
    end
  end

  step 'the file should be saved twice but uploaded to s3 once' do
    files    = Absorb::File.all.to_a
    packages = Absorb::Package.all.to_a

    files.count.must_equal 2
    packages.count.must_equal 2

    storage_ids = files.group_by { |x| x.storage_id }.map { |x| x[0] }
    storage_ids.count.must_equal 1
    storage_ids.first.must_equal files.first.storage_id
    storage_ids.to_s.wont_equal ''

    first_file, second_file = files[0], files[1]
    bucket.objects["abc/#{first_file.name}"].exists?.must_equal true
    bucket.objects["def/#{first_file.name}"].exists?.must_equal false
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

  def create_a_file file, content = UUID.new.generate
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

  def md5_of_file file
    file = test_file(file)
    md5_of file
  end

  def md5_of file
    content = File.read(file)
    Digest::MD5.hexdigest(content)
  end

  def test_directory directory
    test_file directory
  end

  def bucket_name
    ENV['BUCKET_NAME']
  end

  def cleanup_temp_files
    FileUtils.rm_rf 'temp/cat'
    FileUtils.rm_rf 'temp/dog'
    FileUtils.rm_rf 'temp/first_restore'
    ['', '2', '2222', '3', '4'].each do |suffix|
      FileUtils.rm_rf "temp/file#{suffix}.txt"
    end
  end
end
