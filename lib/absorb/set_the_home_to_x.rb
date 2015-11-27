module Absorb

  class SetTheHomeToX < Onus::Step

    REGEX = /Set the home to (.*)/i

    def self.can_build? definition
      definition.scan(REGEX).count > 0
    end

    def execute _
      store[:home] = definition.scan(REGEX)[0][0]
      puts store[:home]
    end

  end

end

