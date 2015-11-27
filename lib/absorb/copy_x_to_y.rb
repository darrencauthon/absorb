require 'fileutils'

module Absorb

  class CopyXToYIfTheFileShouldBeAbsorbed < Onus::Step

    REGEX = /Copy (.*) to (.*) if the file should be absorbed/i

    def self.can_build? definition
      definition.scan(REGEX).count > 0
    end

    def execute _
      source      = definition.scan(REGEX)[0][0]
      destination = definition.scan(REGEX)[0][1]

      files_to_absorb = store[:files_to_absorb].map { |x| x[:file] }
      return unless files_to_absorb.include?(source)

      FileUtils.mkdir_p(File.dirname(destination))
      FileUtils.cp(source, destination)
    end

  end

end

