module Absorb

  class CreateAJsonFileToStoreTheResults < Onus::Step

    REGEX = /Create a json file to store the results/i

    def self.can_build? definition
      definition.scan(REGEX).count > 0
    end

    def execute _
      new_file = "#{store[:storage_location]}.json"
      data = {
               files: store[:files_to_absorb]
                        .map do |f|
                               {
                                 original_file: f[:file],
                                 file:          f[:file].sub(store[:home], ''),
                                 md5:           f[:md5],
                                 size:          f[:size],
                               }
                             end
             }
      File.write new_file, data.to_json
    end

  end

end
