module Absorb
  class Absorber
    def absorb files
      upload = Absorb::Upload.create(uuid: Absorb::Guid.generate)
      files.each { |f| add f, upload }
    end

    private

    def add file, upload
      file_name = get_the_file_name_from file
      Absorb::File.create(uuid: upload.uuid, name: file_name)
      s3.store_file file, "#{upload.uuid}/#{file_name}"
    end

    def s3
      Absorb::AmazonS3.new
    end

    def get_the_file_name_from file
      segments = file.split('/')
      segments.shift if segments.count > 1
      segments.join('/')
    end
  end
end
