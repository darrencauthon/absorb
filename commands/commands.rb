module Commands

  def self.the_appropriate_command
    puts arguments.inspect
    puts options.inspect
    command_type.new arguments, options
  end

  private

  def self.command_type
    @command_type ||= Commands::Base.commands.select { |x| x.command_name == ARGV[0] }.first || Default
  end

  def self.options
    @options ||= command_type.option_parser.options
  end

  def self.arguments
    return @arguments if @arguments
    @arguments = ARGV
    @arguments.shift unless command_type == Default
    @arguments
  end
end
