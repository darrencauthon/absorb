module Absorb

  class RecordTheFileInDynamo < Worker

    def initialize
      handles :record_the_file_in_dynamo
    end

    def process
      create_the_file
      save_important_details_for_later
    end

    def save_important_details_for_later
      effort.data['package_uuid']  = package.uuid
      effort.data['relative_file'] = relative_file
    end

    def create_the_file
      effort.data['md5'] = md5_hash_of_file
      file = Absorb::File.create(uuid: package.uuid, 
                                 name: relative_file,
                                 storage_id: package.uuid,
                                 md5:  effort.data['md5'])
      effort.data['the_file_id'] = file.id
    end

    def md5_hash_of_file
      Digest::MD5.hexdigest(::File.read(file))
    end

    def get_the_relative_file_from file
      segments = file.split('/')
      segments.shift if segments.count > 1
      segments.join('/')
    end

    def file
      effort.data['file']
    end

    def relative_file
      get_the_relative_file_from file
    end

    def package
      @package ||= Absorb::Package.find(effort.data['package_id'])
    end

  end

end
