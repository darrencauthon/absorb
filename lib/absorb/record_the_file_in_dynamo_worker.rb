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

end
