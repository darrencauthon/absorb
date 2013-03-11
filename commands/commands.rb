module Commands
  def self.the_appropriate_command
    global = Commands::Base.default_option_parser
    global.order!
    name = ARGV.shift
    subcommand = Commands::Base.commands.select { |x| x.command_name == name }.first
    subcommand ? subcommand.new.option_parser : global
  end
end
