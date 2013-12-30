module Absorb

  class DetermineIfTheFileShouldBeUploadedWorker < Seam::Worker

    def initialize
      handles :determine_this_files_status_in_the_system
    end

    def process
      file          = Absorb::File.find effort.data['the_file_id']
      similar_files = Absorb::File.where(md5: effort.data['md5'])
      similar_files = similar_files.select { |x| x.id != file.id }
      if similar_files.count == 0
        file.storage_id = file.uuid
      else
        file.storage_id = similar_files.first.storage_id
      end
      file.save
    end

  end

end
