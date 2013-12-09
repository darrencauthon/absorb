module Absorb

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

end
