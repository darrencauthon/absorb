require_relative 'common'

class Spinach::Features::AbsorbFiles < Spinach::FeatureSteps
  step 'I have a file' do
    @file = 'file.txt'
  end

  step 'I absorb the file' do
    Absorb.file @file
  end

  step 'the file should be uploaded to S3' do
    pending 'start by determining how to judge this'
  end
end
