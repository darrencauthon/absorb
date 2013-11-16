module Absorb
  class Absorber
    def initialize s3
      @s3 = s3
    end

    def absorb file
      @s3.store_file file
      upload = Upload.new
      upload.filename = file.split('/')[-1]
      upload.save
    end
  end
end
