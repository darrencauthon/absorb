module Absorb

  class SetTheAbsorbFolderToX < Onus::Step

    REGEX = /Set the absorb folder to (.*)/i

    def self.can_build? definition
      definition.scan(REGEX).count > 0
    end

    def execute _
      store[:absorb_folder] = definition.scan(REGEX)[0][0]
      puts "ABSORB"
      puts store[:absorb_folder]
    end

  end

end

