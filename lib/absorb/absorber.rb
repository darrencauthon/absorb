module Absorb
  class Absorber
    def absorb file

      name = file.split('/')[-1]

      Absorb::File.create(uuid: Absorb::Guid.generate, name: name)
      upload = Absorb::Upload.create(uuid: Absorb::Guid.generate)

      s3 = Absorb::AmazonS3.new
      s3.store_file file, "#{upload.uuid}/#{name}"
    end
  end
end
