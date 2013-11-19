module Absorb
  class Absorber
    def absorb file
      upload = Absorb::Upload.create(uuid: Absorb::Guid.generate)

      s3 = Absorb::AmazonS3.new
      s3.store_file file, "#{upload.uuid}/#{file.split('/')[-1]}"
    end
  end
end
