require_relative '../spec_helper'

describe Amazon do

  describe "startup" do

    let(:settings) do
      {
        access_key_id:      Object.new,
        secret_access_key:  Object.new,
        dynamo_db_endpoint: Object.new,
        dynamodb_upload:    Object.new
      }
    end

    before do
      Absorb.stubs(:settings).returns settings
    end

    describe "basic use" do

      before do

        AWS.expects(:config).with do |x|
          [:access_key_id, :secret_access_key, :dynamo_db_endpoint].each do |key|
            x[key].must_be_same_as settings[key] 
          end
          true
        end

        Dynamoid.expects(:configure)

        Amazon.instance_eval { @started_up = false }
        Amazon.startup
      end

      it "should setup amazon" do
        # expectation above
      end

      it "should fire up dynamodb" do
        # expectation set above
      end

    end

  end

end
