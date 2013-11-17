require_relative '../spec_helper'

describe Absorb::Guid do
  describe "generate" do
    it "should return a new uuid" do
      the_guid = Object.new

      uuid = Object.new
      uuid.stubs(:generate).returns the_guid
      UUID.stubs(:new).returns uuid

      Absorb::Guid.generate.must_be_same_as the_guid
    end
  end
end
