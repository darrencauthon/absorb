module Absorb
  module Guid
    def self.generate
      UUID.new.generate
    end
  end
end
