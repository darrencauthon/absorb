module Absorb
  class Absorber
    def initialize s3
      @s3 = s3
    end

    def absorb file
      @s3.store_file file
    end
  end
end
