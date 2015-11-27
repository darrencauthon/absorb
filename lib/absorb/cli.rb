module Absorb

  module CLI

    def self.run argv

      files = if File.exist?(argv[0]) && File.directory?(argv[0]) == false
                [File.expand_path(File.dirname(argv[0]) + '/' + argv[0])]
              else
                all_files_in(argv[0]).map { |x| File.expand_path(File.dirname(x) + '/' + x.split('/')[-1]) }
              end

      home = if File.exist?(argv[0]) && File.directory?(argv[0]) == false
               File.expand_path(File.dirname(argv[0]))
             else
               File.expand_path(argv[0])
             end

      plan = Absorb.checking_script_for( { home: home, files: files } )
      workflow = Onus::Workflow.new plan

      workflow.execute
    end

    class << self

      private

      def all_files_in dir
        Dir[ File.join(dir, '**', '*') ].reject { |p| File.directory? p }
      end 

    end

  end

end
