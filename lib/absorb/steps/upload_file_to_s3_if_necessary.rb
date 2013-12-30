module Absorb

  class UploadFileToS3IfNecessary < Worker

    def initialize
      handles :upload_file_to_s3_if_necessary
    end

    def process
      return if file_was_uploaded_previously
      s3.store_file file, "#{package_uuid}/#{relative_file}"
    end

    private

    def file_was_uploaded_previously
      effort.data['file_uploaded_previously']
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
