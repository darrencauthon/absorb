module Absorb
  class Absorber
    def initialize s3
      @s3 = s3
    end

    def absorb file
      Upload.upload file
    end
  end
end
