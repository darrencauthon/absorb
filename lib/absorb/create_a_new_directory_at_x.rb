module Absorb

  class CreateANewDirectoryAtX < Onus::Step

    REGEX = /Create a new directory at (.*)/i

    def self.can_build? definition
      definition.scan(REGEX).count > 0
    end

    def execute _
      new_directory = definition.scan(REGEX)[0][0]
      store[:storage_location] = new_directory
    end

  end

end
