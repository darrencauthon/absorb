module Absorb
  class Absorber
    def initialize s3
      @s3 = s3
    end

    def absorb file
      upload = Upload.new
      upload.upload file
    end
  end
end
