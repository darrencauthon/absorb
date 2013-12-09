module Absorb

  class UploadFileToS3Worker < Seam::Worker

    def initialize
      handles :upload_file_to_s3
    end

    def process
      s3.store_file file, "#{package_uuid}/#{relative_file}"
    end

    def s3
      Absorb::AmazonS3.new
    end

    def file
      effort.data['file']
    end

    def relative_file
      effort.data['relative_file']
    end

    def package_uuid
      effort.data['package_uuid']
    end

  end

end
