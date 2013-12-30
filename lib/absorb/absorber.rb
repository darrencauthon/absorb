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
      flow.determine_this_files_status_in_the_system
      flow.upload_file_to_s3_if_necessary
      flow
    end

    def absorb files
      create_the_work_to_upload files
      complete_the_work
    end

    private

    def create_the_work_to_upload files
      package_data = { absorb_uuid: Absorb::Guid.generate }
      self.class.package_flow_for(files).start package_data
    end

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
                          create_a_package:                          CreateAPackage,
                          add_a_file_to_the_package:                 AddAFileToThePackage,
                          upload_file_to_s3_if_necessary:            UploadFileToS3IfNecessary,
                          determine_this_files_status_in_the_system: DetermineThisFilesStatusInTheSystem,
                          record_the_file_in_dynamo:                 RecordTheFileInDynamo
                        }
    end


  end

end
