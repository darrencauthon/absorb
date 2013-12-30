module Absorb

  class DetermineIfTheFileShouldBeUploadedWorker < Seam::Worker

    def initialize
      handles :determine_this_files_status_in_the_system
    end

    def process
      file = Absorb::File.find effort.data['the_file_id']
      files = Absorb::File.where(md5: effort.data['md5'])
      files = files.select { |x| x.id != file.id }
      if files.count == 0
        file.storage_id = file.uuid
      else
        file.storage_id = files.first.uuid
      end
      file.save
    end

  end

end
