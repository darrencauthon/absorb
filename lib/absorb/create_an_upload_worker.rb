module Absorb

  class RecordTheFileInDynamoWorker < Seam::Worker
    def initialize
      handles :record_the_file_in_dynamo
    end

    def process
      file = effort.data['file']
      package = Absorb::Package.find(effort.data['package_id'])
      relative_file = get_the_relative_file_from effort.data['file']
      Absorb::File.create(uuid: package.uuid, name: relative_file)
      effort.data['package_uuid'] = package.uuid
      effort.data['relative_file'] = relative_file
    end

    def get_the_relative_file_from file
      segments = file.split('/')
      segments.shift if segments.count > 1
      segments.join('/')
    end
  end

  class UploadFileToS3Worker < Seam::Worker
    def initialize
      handles :upload_file_to_s3
    end

    def process
      file          = effort.data['file']
      relative_file = effort.data['relative_file']
      package_uuid   = effort.data['package_uuid']
      s3.store_file file, "#{package_uuid}/#{relative_file}"
    end

    def s3
      Absorb::AmazonS3.new
    end

  end

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

  class CreateAPackageWorker < Seam::Worker

    def initialize
      handles :create_a_package
    end

    def process
      package = Absorb::Package.create(uuid: effort.data['absorb_uuid'])
      self.effort.data['package_id'] = package.id
    end
  end
end
