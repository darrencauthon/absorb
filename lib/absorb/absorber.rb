module Absorb

  class Absorber

    def self.file_flow
      flow = Seam::Flow.new
      flow.upload_file_to_s3
      flow.record_the_upload_in_dynamo
      flow
    end

    def self.upload_flow
      flow = Seam::Flow.new
      flow.create_an_upload
      flow.upload_the_files
      flow
    end

    def absorb files
      upload_id = Absorb::Guid.generate
      effort = self.class.upload_flow.start( { absorb_uuid: upload_id, files: files } )
      CreateAnUploadWorker.new.execute_all
      #puts Seam::Effort.find_all_by_step('create_an_upload').count.inspect
      #upload = Absorb::Upload.create(uuid: upload_id)
      #files.each { |f| add f, upload }
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
