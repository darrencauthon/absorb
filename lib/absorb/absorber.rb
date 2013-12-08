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
      upload_id = Absorb::Guid.generate
      effort = self.class.upload_flow(files).start( { absorb_uuid: upload_id, files: files } )
      CreateAnUploadWorker.new.execute_all
      AddTheFileToAnUploadWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
      UploadFileToS3Worker.new.execute_all
      RecordTheUploadInDynamoWorker.new.execute_all
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
