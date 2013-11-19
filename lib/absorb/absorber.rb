module Absorb
  class Absorber
    def absorb files

      upload = Absorb::Upload.create(uuid: Absorb::Guid.generate)

      files.each do |file|
        name = file.split('/')[-1]

        Absorb::File.create(uuid: upload.uuid, name: name)

        s3 = Absorb::AmazonS3.new
        s3.store_file file, "#{upload.uuid}/#{name}"
      end
    end
  end
end
