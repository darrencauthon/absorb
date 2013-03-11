module Commands
  def self.the_appropriate_command
    name = ARGV[0]

    command_type = Commands::Base.commands.select { |x| x.command_name == name }.first || Default
    options = command_type.option_parser.options
    arguments = ARGV
    puts arguments.inspect
    puts options.inspect
    command_type.new arguments, options
  end
end
