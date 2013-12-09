module Absorb

  class RecordTheUploadInDynamoWorker < Seam::Worker
    def initialize
      handles :record_the_upload_in_dynamo
    end

    def process
      file = effort.data['file']
      upload = Absorb::Package.find(effort.data['upload_id'])
      relative_file = get_the_relative_file_from effort.data['file']
      Absorb::File.create(uuid: upload.uuid, name: relative_file)
      effort.data['upload_uuid'] = upload.uuid
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
      upload_uuid   = effort.data['upload_uuid']
      s3.store_file file, "#{upload_uuid}/#{relative_file}"
    end

    def s3
      Absorb::AmazonS3.new
    end

  end

  class AddTheFileToAnUploadWorker < Seam::Worker

    def initialize
      handles :add_the_file_to_an_upload
    end

    def process
      file = current_step['arguments'][0]['file']
      data = { file: file, upload_id: effort.data['upload_id'] }
      ::Absorb::Absorber.file_flow.start data
    end
  end

  class CreateAnUploadWorker < Seam::Worker

    def initialize
      handles :create_an_upload
    end

    def process
      upload = Absorb::Package.create(uuid: effort.data['absorb_uuid'])
      self.effort.data['upload_id'] = upload.id
    end
  end
end
