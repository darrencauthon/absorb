require 'onus'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each { |f| require f }

module Absorb

  def self.checking_script_for options
    [
      plan_to_absorb_every_file(options),
      create_the_new_storage_folder(options),
      copy_the_files_to_the_storage_folder(options),
    ].flatten.join "\n"
  end

  class << self

    def plan_to_absorb_every_file options
      options[:files]
        .map { |f| "Plan to absorb #{f} if it has not been absorbed" }
    end

    def create_the_new_storage_folder options
      "Create a new directory at #{options[:storage_folder]}"
    end

    def copy_the_files_to_the_storage_folder options
      options[:files]
        .map  { |f| "Copy #{f} to #{options[:storage_folder]}#{f.sub(options[:home], '')} if the file should be absorbed" }
    end

  end

end
