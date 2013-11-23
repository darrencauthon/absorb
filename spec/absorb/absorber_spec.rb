require_relative '../spec_helper'

describe Absorb::Absorber do

  describe "absorb" do

    describe "single file situation" do

      let(:files)    { ["one"] }
      let(:s3)       { Object.new }
      let(:guid)     { Object.new }

      let(:upload) do
        [:uuid].to_objects { [[guid]] }.first
      end

      let(:absorber) do
        a = Absorb::Absorber.new
        a.stubs(:s3).returns s3
        a
      end

      before do
        Absorb::Guid.stubs(:generate).returns guid
        Absorb::Upload.stubs(:create).with(uuid: guid).returns upload
        Absorb::File.expects(:create).with(uuid: guid, name: "one")
        s3.expects(:store_file).with("one", "#{guid}/one")

        absorber.absorb files
      end

      it "should create a new file" do
        # expectation set above
      end

      it "should store the file in s3" do
        # expectation set above
      end

    end

  end

end
