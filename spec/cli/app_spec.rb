require_relative '../spec_helper'

describe Absorb::App do

  describe "with_config" do

    it "should return an absorb::app, having received the config" do

      config = Object.new
      app = Absorb::App.with_config config

      app.instance_eval { @config }.must_be_same_as config
        
    end

  end

end
