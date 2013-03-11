module Commands
  class File < Commands::Base

    def self.command_name
      'file'
    end

    def execute
      puts self.class.option_parser
    end

    def self.option_parser
      the_options = {}
      parser = OptionParser.new do |opt|
                 opt.banner = "Usage: absorb #{command_name} [filename]"
                 opt.separator ''
                 opt.separator 'Options'

                 opt.on('-h','--help','help') do
                   the_options[:help] = true
                 end
               end

      parser.parse!
      parser.options = the_options
      parser
    end
  end
end
