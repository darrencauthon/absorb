module Absorb

  module FileSystem

    def self.files_from directory
      directories = Dir.entries(directory).select { |d| ::File.directory?(d) }.select { |x| ['.', '..'].include?(x) == false }
      [directories.map { |d| Absorb::FileSystem.files_from directory },
       Dir.entries(directory).select { |f| ::File.directory?(f) == false }.flatten.map { |f| "#{directory}/#{f}" }].flatten
    end

  end

end
