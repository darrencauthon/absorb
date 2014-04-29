module Absorb

  class App

    def initialize config
      @config = config
    end

    def self.with_config config
      Absorb::App.new config
    end

  end

end
