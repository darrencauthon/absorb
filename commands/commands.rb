module Commands
  def self.the_appropriate_command
    global = default_option_parser
    global.order!
    name = ARGV.shift
    subcommand = Commands::Base.commands.select { |x| x.command_name == name }.first
    subcommand ? subcommand.new.option_parser : global
  end

  private

  def self.default_option_parser
    OptionParser.new do |opt|
      opt.banner = 'Usage: absorb COMMAND [OPTIONS]'
      opt.separator ''
      opt.separator 'Commands'
      opt.separator '     file: Absorb a file.'
      opt.separator ''
      opt.separator 'Options'

      opt.on('-h','--help','help') do
        puts option_parser
      end
    end
  end
end
