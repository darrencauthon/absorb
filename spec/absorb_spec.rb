require_relative 'spec_helper'

describe Absorb do

  describe "files" do

    let(:files)    { Object.new }
    let(:absorber) { Object.new }

    before do
      Amazon.stubs(:startup)

      Absorb::Absorber.stubs(:new).returns absorber
      absorber.stubs(:absorb).with files

    end

    it "should start up Amazon" do
      Amazon.expects(:startup)
      Absorb.files files
    end

    it "should create an absorber and pass along the files" do
      absorber.expects(:absorb).with files
      Absorb.files files
    end

  end

end
