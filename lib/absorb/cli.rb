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

      def execution_plan_from argv
        files = requested_files_from argv
        home  = home_folder_from argv

        Absorb.checking_script_for( { home: home, files: files } )
      end

      def requested_files_from argv
        if File.exist?(argv[0]) && File.directory?(argv[0]) == false
          [File.expand_path(File.dirname(argv[0]) + '/' + argv[0])]
        else
          all_files_in(argv[0]).map { |x| File.expand_path(File.dirname(x) + '/' + x.split('/')[-1]) }
        end
      end

      def home_folder_from argv
        if File.exist?(argv[0]) && File.directory?(argv[0]) == false
          File.expand_path(File.dirname(argv[0]))
        else
          File.expand_path(argv[0])
        end
      end

    end

  end

end
