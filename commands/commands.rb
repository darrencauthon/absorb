module Commands
  def self.the_appropriate_command
    global = Commands::Default.new.option_parser
    global.order!
    name = ARGV.shift

    command_type = Commands::Base.commands.select { |x| x.command_name == name }.first || Default
    command_type.new
  end
end
