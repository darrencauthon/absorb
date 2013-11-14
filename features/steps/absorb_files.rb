require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps
  step 'I have a file' do
    @file = 'file.txt'
    create_a_file @file
  end

  step 'I absorb the file' do
    Absorb.file @file
  end

  step 'the file should be uploaded to S3' do
    pending 'start by determining how to judge this'
  end

  def create_a_file file, content = 'x'
    File.open('temp/file.txt', 'w') { |file| file.write(content) }
  end
end
