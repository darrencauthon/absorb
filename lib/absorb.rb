require 'onus'
Dir[File.dirname(__FILE__) + '/absorb/*.rb'].each {|file| require file }

module Absorb

  def self.checking_script_for(options)
    commands = []
    options[:files]
      .map  { |f| "Plan to absorb #{f} if it has not been absorbed" }
      .each { |c| commands << c }

    storage_folder = "/Users/darrencauthon/darren/absorb/blah/#{SecureRandom.uuid}"

    commands << "Create a new directory at #{storage_folder}"

    options[:files]
      .map  { |f| "Copy #{f} to #{storage_folder}#{f.sub(options[:home], '')} if the file should be absorbed" }
      .each { |c| commands << c }

    commands.join("\n")
  end

end
