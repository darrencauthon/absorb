module Absorb
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
