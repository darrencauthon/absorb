module Commands
  class Default < Base
    def execute
      puts option_parser
    end

    def option_parser
      OptionParser.new do |opt|
        opt.banner = 'Usage: absorb COMMAND [OPTIONS]'
        opt.separator ''
        opt.separator 'Commands'
        opt.separator '     file: Absorb a file.'
        opt.separator ''
        opt.separator 'Options'

        #opt.on('-h','--help','help') do
          #puts option_parser
        #end
      end
    end
  end
end
