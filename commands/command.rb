module Commands

  def self.the_appropriate_command
    global = Commands::Base.opt_parser
    global.order!
    name = ARGV.shift
    subcommand = Commands::Base.commands.select { |x| x.command_name == name }.first
    subcommand ? subcommand.option_parser : global
  end

  module Base
    class << self
      attr_accessor :commands
      def included(command)
        @commands ||= []
        @commands << command
      end

      def opt_parser
        OptionParser.new do |opt|
          opt.banner = 'Usage: absorb COMMAND [OPTIONS]'
          opt.separator ''
          opt.separator 'Commands'
          opt.separator '     file: Absorb a file.'
          opt.separator ''
          opt.separator 'Options'

          opt.on('-h','--help','help') do
            puts opt_parser
          end
        end
      end
    end
  end
end
