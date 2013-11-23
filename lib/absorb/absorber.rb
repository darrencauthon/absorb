module Absorb

  class Absorber

    def absorb files
      upload = Absorb::Upload.create(uuid: Absorb::Guid.generate)
      files.each { |f| add f, upload }
    end

    private

    def add file, upload
      relative_file = get_the_relative_file_from file
      Absorb::File.create(uuid: upload.uuid, name: relative_file)
      s3.store_file file, "#{upload.uuid}/#{relative_file}"
    end

    def s3
      Absorb::AmazonS3.new
    end

    def get_the_relative_file_from file
      segments = file.split('/')
      segments.shift if segments.count > 1
      segments.join('/')
    end

  end

end
