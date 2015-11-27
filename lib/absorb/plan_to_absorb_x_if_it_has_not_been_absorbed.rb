module Absorb

  class PlanToAbsorbX < Onus::Step

    REGEX = /Plan to absorb (.*) if it has not been absorbed/i

    def self.can_build? definition
      definition.scan(REGEX).count > 0
    end

    def execute input
      store[:files_to_absorb] ||= []
      store[:files_to_absorb] << file_to_absorb
    end

    def file_to_absorb
      { 
        file: file,
        md5:  md5,
        size: size,
      }
    end

    def file
      definition.scan(REGEX)[0][0]
    end

    def md5
      Digest::MD5.file(file).hexdigest
    end

    def size
      File.size file
    end

  end

end
