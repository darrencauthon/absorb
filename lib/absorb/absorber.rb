module Absorb

  class Absorber

    def self.package_flow_for files
      flow = Seam::Flow.new
      flow.create_a_package
      files.each { |f| flow.add_a_file_to_the_package(file: f) }
      flow
    end

    def self.file_flow
      flow = Seam::Flow.new
      flow.record_the_file_in_dynamo
      flow.upload_file_to_s3
      flow
    end

    def absorb files
      package_data = { absorb_uuid: Absorb::Guid.generate, 
                       files: files }
      self.class.package_flow_for(files).start package_data
      complete_the_work
    end

    private

    def complete_the_work
      while steps_to_run.count > 0
        steps_to_run.each { |s| things_to_do[s.to_sym].new.execute_all }
      end
    end

    def steps_to_run
      Seam.steps_to_run
    end

    def things_to_do
      @things_to_do ||= { 
                          create_a_package:          CreateAPackageWorker,
                          add_a_file_to_the_package: AddAFileToThePackageWorker,
                          upload_file_to_s3:         UploadFileToS3Worker,
                          record_the_file_in_dynamo: RecordTheFileInDynamoWorker
                        }
    end


  end

end
