module Absorb

  class Absorber

    def self.package_flow files
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

      self.class.package_flow(files)
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
