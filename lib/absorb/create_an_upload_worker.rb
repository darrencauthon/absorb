module Absorb

  class UploadTheFilesWorker < Seam::Worker
    def initialize
      handles :upload_the_files
    end

    def process
      effort.data['files'].each do |file|
        data = { file: file, upload_id: effort.data['upload_id'] }
        ::Absorb::Absorber.file_flow.start( data )
      end
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
