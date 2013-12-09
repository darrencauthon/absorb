module Absorb

  class Absorber

    def self.file_flow
      flow = Seam::Flow.new
      flow.record_the_upload_in_dynamo
      flow.upload_file_to_s3
      flow
    end

    def self.upload_flow files
      flow = Seam::Flow.new
      flow.create_an_upload
      files.each { |f| flow.add_the_file_to_an_upload(file: f) }
      flow
    end

    def absorb files

      self.class.upload_flow(files)
                  .start( { absorb_uuid: Absorb::Guid.generate, files: files } )

      steps_to_run = Seam.steps_to_run
      while steps_to_run.count > 0
        steps_to_run.each do |step|
          things_to_do[step.to_sym].new.execute_all
        end
        steps_to_run = Seam.steps_to_run
      end

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

    def things_to_do
      @things_to_do ||= { 
                          create_an_upload:            CreateAnUploadWorker,
                          add_the_file_to_an_upload:   AddTheFileToAnUploadWorker,
                          upload_file_to_s3:           UploadFileToS3Worker,
                          record_the_upload_in_dynamo: RecordTheUploadInDynamoWorker
                        }
    end


  end

end
