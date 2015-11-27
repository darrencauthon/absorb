require 'onus'
require 'json'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each { |f| require f }

module Absorb

  def self.checking_script_for options
    [
      set_the_home(options),
      plan_to_absorb_every_file(options),
      create_the_new_storage_folder(options),
      copy_the_files_to_the_storage_folder(options),
      create_a_json_file_to_store_the_results(options),
    ].flatten.join "\n"
  end

  class << self

    def set_the_home options
      "Set the home to #{options[:home]}"
    end

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

    def create_a_json_file_to_store_the_results options
      "Create a json file to store the results"
    end

  end

end
