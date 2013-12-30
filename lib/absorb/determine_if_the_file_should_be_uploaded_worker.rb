module Absorb

  class DetermineIfTheFileShouldBeUploadedWorker < Seam::Worker

    def initialize
      handles :determine_this_files_status_in_the_system
    end

    def process
      file = retrieve_this_file
      file.storage_id = the_appropriate_file_storage_id_for file
      file.save
    end

    private

    def the_appropriate_file_storage_id_for file
      similar_files = find_similar_files_to file
      if similar_files.count > 0
        effort.data['file_uploaded_previously'] = true
        similar_files.first.storage_id
      else
        file.uuid
      end
    end

    def retrieve_this_file
      Absorb::File.find effort.data['the_file_id']
    end

    def find_similar_files_to file
      similar_files = Absorb::File.where(md5: effort.data['md5'])
      similar_files.select { |x| x.id != file.id }
    end

  end

end
