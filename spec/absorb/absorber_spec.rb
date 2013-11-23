require_relative '../spec_helper'

describe Absorb::Absorber do

  describe "files" do

    let(:files)    { Object.new }
    let(:absorber) { Object.new }

    before do
      Amazon.expects(:startup)

      Absorb::Absorber.stubs(:new).returns absorber
      absorber.expects(:absorb).with files

      Absorb.files files
    end

    it "should start up Amazon" do
      # expectation set above
    end

    it "should create an absorber and pass along the files" do
      # expectation set above
    end

  end

end
