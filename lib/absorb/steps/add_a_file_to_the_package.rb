module Absorb

  class AddAFileToThePackage < ::Absorb::Worker

    def initialize
      handles :add_a_file_to_the_package
    end

    def process
      ::Absorb::Absorber.file_flow.start data
    end

    private

    def data
      { 
        file:       current_step['arguments'][0]['file'],
        package_id: effort.data['package_id']
      }
    end

  end

end
