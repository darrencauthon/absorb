module Absorb
  class Absorber
    def absorb files
      upload = Absorb::Upload.create(uuid: Absorb::Guid.generate)
      files.each { |f| add f, upload }
    end

    private

    def add file, upload
      segments = file.split('/')
      if segments.count > 1
        segments.shift
      end
      name = segments.join('/')

      Absorb::File.create(uuid: upload.uuid, name: name)

      s3 = Absorb::AmazonS3.new
      s3.store_file file, "#{upload.uuid}/#{name}"
    end
  end
end
