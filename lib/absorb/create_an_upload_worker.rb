module Absorb

  class AddTheFileToAnUploadWorker < Seam::Worker

    def initialize
      handles :add_the_file_to_an_upload
    end

    def process
      data = { file: effort.data['file'], upload_id: effort.data['upload_id'] }
      ::Absorb::Absorber.file_flow.start data
    end
  end

  class CreateAnUploadWorker < Seam::Worker

    def initialize
      handles :create_an_upload
    end

    def process
      upload = Absorb::Upload.create(uuid: effort.data['absorb_uuid'])
      self.effort.data['upload_id'] = upload.id
    end
  end
end
