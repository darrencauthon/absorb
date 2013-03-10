module Commands
  module File
    include Commands::Base
    class << self

      def command_name
        'file'
      end

      def option_parser
        OptionParser.new do |opt|
          opt.banner = "Usage: absorb #{command_name} [filename]"
          opt.separator ''
          opt.separator 'Options'

          opt.on('-m','--message','runing on daemon mode?') do |message|
            options[:message] = message
          end

          opt.on('-h','--help','help') do
            puts opt_parser
          end
        end
      end
    end
  end
end
