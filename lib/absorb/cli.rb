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
        if File.exist?(path) && File.directory?(path) == false
          [File.expand_path(File.dirname(path) + '/' + path)]
        else
          all_files_in(path).map { |x| File.expand_path(File.dirname(x) + '/' + x.split('/')[-1]) }
        end
      end

      def home_folder_from argv
        path = path_to_absorb_from argv
        if File.exist?(path) && File.directory?(path) == false
          File.expand_path(File.dirname(path))
        else
          File.expand_path(path)
        end
      end

    end

  end

end
