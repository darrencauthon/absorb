module Commands
  def self.the_appropriate_command
    global = Commands::Default.option_parser
    name = ARGV.shift

    command_type = Commands::Base.commands.select { |x| x.command_name == name }.first || Default
    command_type.new ARGV, global.options
  end
end
