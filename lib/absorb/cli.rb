module Absorb

  module CLI

    def self.run argv
      plan = execution_plan_from argv

      Onus::Workflow.new(plan).execute
    end

    class << self

      private

      def all_files_in dir
        Dir[ File.join(dir, '**', '*') ].reject { |p| File.directory? p }
      end 

      def path_to_absorb_from argv
        argv[0]
      end

      def execution_plan_from argv
        files = requested_files_from argv
        home  = home_folder_from argv

        Absorb.checking_script_for( { home: home, files: files } )
      end

      def requested_files_from argv
        path = path_to_absorb_from argv
        single_file?(path) ? [File.expand_path(File.dirname(path) + '/' + path)]
                           : all_files_in(path).map { |x| File.expand_path(File.dirname(x) + '/' + x.split('/')[-1]) }
      end

      def home_folder_from argv
        path = path_to_absorb_from argv
        single_file?(path) ? File.expand_path(File.dirname(path))
                           : File.expand_path(path)
      end

      def single_file? path
        File.exist?(path) && File.directory?(path) == false
      end

    end

  end

end
