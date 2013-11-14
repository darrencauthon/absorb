require_relative 'spec_helper'

describe Absorb do

  ['test.txt', 'test2.txt'].each do |file|

    describe "file" do

      it "should store #{file} in s3" do
        Absorb::AmazonS3.expects(:store_file).with file
        Absorb.file file
      end

    end

  end

end
