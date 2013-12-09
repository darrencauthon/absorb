module Absorb

  class AddAFileToThePackageWorker < Seam::Worker

    def initialize
      handles :add_a_file_to_the_package
    end

    def process
      file = current_step['arguments'][0]['file']
      data = { file: file, package_id: effort.data['package_id'] }
      ::Absorb::Absorber.file_flow.start data
    end

  end

end
