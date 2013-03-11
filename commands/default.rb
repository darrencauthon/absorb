module Commands
  class Default < Base

    def execute
      puts self.class.option_parser
    end

    def self.option_parser
      the_options = {}
      parser = OptionParser.new do |opt|
                 opt.banner = 'Usage: absorb COMMAND [OPTIONS]'
                 opt.separator ''
                 opt.separator 'Commands'
                 opt.separator '     file: Absorb a file.'
                 opt.separator ''
                 opt.separator 'Options'

                 opt.on('-h','--help','help') do
                   the_options[:help] = true
                 end
               end

      parser.options = the_options
      parser.order!
      parser
    end
  end
end
